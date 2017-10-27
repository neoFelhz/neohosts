#!/bin/env ruby

# hostsgen is a tool for managing hosts projects

#########################################################################
#   Copyright 2017 duangsuse
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#########################################################################

VERSION = "0.1.1"
CFG_FILENAME = "hostsgen.yml"
MOD_FILENAME = "mod.txt"
HEAD_FILENAME = "head.txt"
# valid hostname may contain ASCII char A-Z, a-z, 0-9 and '.', '-'.
HOSTNAME_VALID_CHARS = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890-."

# main function
def start(args)
  options = CmdlineOptions.new(args)
  if !options.silent then
    print "Hostsgen v" + VERSION + "; "
    puts case options.operate
      when 0; "building project..."
      when 1; "checking hosts data..."
      when 2; "cleaning..."
      when 3; "printing help..."
      when 4; "printing version..."
    end
    if options.out then puts "[INFO] Outputting to " + options.out + " ..." end
    if options.no_comments then puts "[INFO] No comments in output file" end
    if options.mod_black_list.length != 0 then print "[INFO] No compile: "; puts options.mod_black_list.to_s end
  end
  if options.operate == 3 then
    puts "Usage: ", $0 + " [build/check/clean/help/version] (args)", "args: -q:quiet -o:out [file] -t:no comments -b(an) [mod]"; exit
  end
  if options.operate == 4 then puts VERSION; exit end
  project_cfg = ProjectConfig.new(options.silent)
  if options.operate == 2 then
    begin
      if not options.out.nil? then File.delete options.out end
      if not project_cfg.out.nil? then File.delete project_cfg.out end
      rescue
      # nil.to_s == ''
      if File.exists? options.out.to_s or File.exists? project_cfg.out.to_s then
        puts "[WARN] failed to delete some file"
      end
    end
    if not (File.exists? options.out.to_s or File.exists? project_cfg.out.to_s) then
      puts "[INFO] Cleaned."
    end
    exit 0
  end
  if options.operate == 1 then
    if File.exists? options.out.to_s or File.exists? project_cfg.out.to_s then
      hosts = Hosts.new
      if File.exists? name=options.out.to_s then
        puts "[CHECK] Checking file " + name
        f = File.open name
        hosts.parse(f.read)
        hosts.check
      else
        name = project_cfg.out.to_s
        puts "[CHECK] Checking file " + name
        f = File.open name
        hosts.parse(f.read)
        hosts.check
      end
    else
      puts "[ERR] Cannot find any build artifacts"; exit 4
    end
    exit 0
  end
  if !options.silent then
    print "[INFO] Project '"
    print project_cfg.name
    print "' by "
    puts project_cfg.authors.to_s
    print "[INFO] Default output: "
    print project_cfg.out
    print " , desc: "
    puts project_cfg.desc
    print "[INFO] Modules: "
    puts project_cfg.mods.to_s
  end
  mods = ProjectModules.new(options.silent, project_cfg.mods, options.mod_black_list)
  print "[COMPILE] Modules: "
  puts mods.mods.to_s
  # if String|nil ...
  if name=options.out then
    mods.build options.silent, options.no_comments, name, project_cfg
  else
    mods.build options.silent, options.no_comments, project_cfg.out, project_cfg
  end
  puts "[COMPILE] OK."
end

# commandline arguments structure&parser
# commandline usage:
# ruby hostsgen.rb [operate] [args]
# operate: build(0) check(1) clean(2) help(3) version(4)
# args: -q: quiet -o: out -t: tidy -b [module]: no compile for module
class CmdlineOptions
  def initialize(cmdline)
    @mod_black_list = []
    @operate = nil
    @out = nil
    @silent = false
    @no_comments = false
    if cmdline.include? "-q" then @silent = true end
    if cmdline.include? "-t" then @no_comments = true end
    if cmdline.include? "-o" then @out = cmdline[(cmdline.index "-o") + 1] end
    cmdline.each_with_index do |i, s|
      if i.start_with? "-b" then @mod_black_list.push cmdline[s + 1] end
    end
    @operate = case cmdline[0]
      when "build"; 0
      when "check"; 1
      when "clean"; 2
      when "help"; 3
      when "version"; 4
      else 0
    end
  end
  #getter
  attr_reader :mod_black_list
  attr_reader :operate
  attr_reader :silent
  attr_reader :no_comments
  def out
    if !@out.nil?;
      if @out.start_with? '-'; puts "[ERR] Output filename should not start with -"; exit 3 end
      if File.directory? @out; puts "[ERR] Cannot use dir as output"; exit 2 end
    end
    return @out
  end
end

# hostsgen project config structure
class ProjectConfig
  def initialize(silent)
    require 'yaml'
    if not File.exist? CFG_FILENAME; puts "[ERR] Project config does not exists"; exit 1 end
    cfg = YAML.load_file(CFG_FILENAME)
    if !silent then puts "[VERBOSE] Parsed YAML:",cfg.inspect end
    @name = cfg["name"]
    @desc = cfg["desc"]
    @out = cfg["out"]
    @authors = cfg["authors"]
    @mods = cfg["mods"]
  end
  #getter
  attr_reader :name
  attr_reader :desc
  attr_reader :out
  attr_reader :authors
  attr_reader :mods
end

# project modules structure
class ProjectModules
  def initialize(quiet, mods, ignored)
    @mods = mods
    # strip desc in module config
    mods.each_with_index do |m, i|
     space_idx = m.index ' '
     if space_idx.nil? and not quiet then puts "[WARN] No description in mod " + m
     else @mods[i] = m[0..space_idx - 1] end
    end
    @mods = @mods - ignored
  end
  def build(quiet, no_comments, out, cfg)
    if not quiet then
      puts "[COMPILE] Outputting to " + out + (" no comments" if no_comments).to_s
    end
    gen = Hosts.new
    begin
      file = File.new out, 'w'
    rescue => e
      puts "[ERR] Cannot write to file!, check your file permission (" + e.to_s + ")"
    end
    begin
      file.puts (File.open HEAD_FILENAME).read + "\n"
    rescue
      puts "[WARN] Head text not found(head.txt)"
    end
    begin
      (file.puts "#Hostsgen project " + cfg.name + " (" + cfg.desc + ") " + "by " + cfg.authors.to_s + "\n") if not ARGV.include? "-t"
    rescue
      puts "[WARN] Cannot put project props"
    end
    @mods.each_with_index do |m, i|
      puts "[COMPILE] Compiling Module #" + i.to_s + ": " + m if not quiet
      if File.exist? m + '/' + MOD_FILENAME then
        f = File.open m + '/' + MOD_FILENAME
        HostsModule.new(f.read).compile m, file, cfg.mods[i]
      else puts "[ERR] Cannot find module config"; exit 5 end
    end
  end
  #getter
  attr_reader :mods
end

# hostsgen module structure&parser
# contains file names, descriptions, generate rules  
class HostsModule
  def initialize(cfg)
    @files = []
    cfg.lines.each_with_index do |line, i|
      begin
        @files.push FileConfig.new line
      rescue => e
        puts "[COMPILE] Failed to parse mod config at line " + i.to_s
        puts "[ERR] " + e.to_s; exit 8
      end
    end
  end
  def compile(m, file, desc)
    file.puts "#Module: " + m + " : " + desc + "\n" if not ARGV.include? "-t"
    for f in @files do
      begin
        l = f.compile m, file
      rescue => e
        puts "[COMPILE] Failed to compile file: " + e.to_s; exit 7
      end
        puts " OK, " + l.to_s + " logs generated." if not ARGV.include? "-q"
    end
    file.puts "#endModule: " + m + "\n" if not ARGV.include? "-t"
  end
end

# module file
# fields: filename, description, genrule
class FileConfig
  def initialize(line)
    desc = "(none)"
    file_ends = line.index ':'
    if file_ends.nil? then puts "[COMPILE] Cannot find ':' in mod"; exit 6 end
    if file_ends == 0 then raise "invalid filename" end
    @file = line[0..file_ends - 1]
    desc_starts = line.index '('
    desc_ends = line.index ')'
    if desc_starts.nil? then puts "[COMPILE] WARN: Cannot find description start" end
    if desc_starts.nil? then puts "[COMPILE] WARN: Cannot find description end" end
    if not desc_starts.nil? and desc_ends.nil? then raise "[COMPILE] ERR: Endless description (missing ')')" end
    if not (desc_starts.nil? or desc_ends.nil?) then  @desc = line[desc_starts + 1..desc_ends -1] end
    if desc_ends.nil? then
      @genrule = line[file_ends + 1..line.length]
    else
      @genrule = line[desc_ends + 1..line.length]
    end
    begin
      @genrule = GenerateRule.new(@genrule.strip)
    rescue => e
      raise "error initializing genrule: " + e.to_s
    end
  end
  # raise a string contains filename, reason
  # return Hosts data
  def compile(m, f)
    print @file + '..' if not ARGV.include? '-q'
    inf = File.open(m + '/' + @file)
    content = inf.read
    hosts = Hosts.new
    hosts.parse content
    hosts.logs.each_with_index do |l, i|
      hosts.logs[i] = @genrule.process l
    end
    f.puts "#FILE: " + @file + " : " + @desc + "\n" if not ARGV.include? '-t'
    f.puts hosts
    return hosts.logs.length 
    f.puts "#FILE: " + @file + "\n" if not ARGV.include? '-t'
  end
end

# generate rule structure
class GenerateRule
  def initialize(line)
    line = line.split ' '
    @host = line[1]
    @loc = line[0]
    raise "too many or few gen args in config" if not line.length == 2
    @host_insert_idx = @host.index "{HOST}"
    @host = @host.tr "{HOST}", "" #blank String is nil in Ruby
    @loc_insert_idx = @loc.index "{IP}"
    @loc = @loc.tr "{IP}", "" 
    @put_in_host = nil
    if a=@host_insert_idx.nil? or @loc_insert_idx.nil? then
      @put_in_host = !a
      raise "must be one format argument valid ({IP} {HOST}) at least" if a and @loc_insert_idx.nil?
    end
  end
  # process a host item using rule
  # return processed item
  def process(hostsitem)
    item = HostsItem.new nil, nil, nil
    if not @put_in_host.nil? then
      if @put_in_host then
        tmp = @host.dup
        tmp.insert @host_insert_idx, hostsitem.loc
        item.set tmp, @loc, hostsitem.line
      else
        tmp = @loc.dup
        tmp.insert @loc_insert_idx, hostsitem.loc
        item.set @host, tmp, hostsitem.line
      end
      return item
    else
      tmp_host = @host.dup
      tmp_host.insert @host_insert_idx, hostsitem.host
      tmp_loc = @loc.dup
      tmp_loc.insert @loc_insert_idx, hostsitem.loc
      item.set tmp_host, tmp_loc, hostsitem.line
      return item
    end
  end
end

# hosts file structure
# hosts structure is a (array of HostsItem) and HostsComments
class Hosts
  def initialize()
    @logs = []
  end
  # parse a String, store data in self
  # valid log should not be started with #
  def parse(hosts)
    hosts.lines.each_with_index do |l, i|
      l = l.strip
      if l[0] == '#' then ; next end
      if l == "" then ; next end
      l = l.split ' '
      #raise "more or less than 2 col at line " + i.to_s + " (hostsgen does not trim non-line comments)(plese use space to split only)" if not l.length == 2
      host = l[1]
      loc = l[0]
      @logs.push (HostsItem.new i, host, loc)
    end
  end
  # lint hosts data
  def check
    lint(@logs)
  end
  # merges self with other
  def push(other)
    push_logs other
  end
  def to_s()
    r = String.new
    for l in @logs do
      r += l.to_s + "\n"
    end
    return r
  end
  def push_logs(o); @logs.push o end
  attr_reader :logs
end

class HostsItem
  def initialize(l, host, loc)
    @line = l #line number
    @host = host #hostname
    @loc = loc #address
  end
  def to_s()
    #if @loc.nil? or @host.nil? then return @loc.to_s||@host.to_s end 
    return @loc + ' ' + @host
  end
  #getter
  attr_reader :line
  attr_reader :host
  attr_reader :loc
  #setter
  def set(h,i,l)
    @line = l
    @host = h
    @loc = i
  end
end

# lint hosts data
# LOC rules (only IPv4 is supported in this file):
# if not l.start_with? "::" then l.assert_in_pattern [0-255].[0-255].[0-255] end
# NAME rules:
# name.assert_only_include HOSTNAME_VALID_CHARS 
def lint(logs)
  require 'ipaddr'
  logs.each_with_index do |l, i|
    hostname_not_valid = false
    puts "[LINT] WARN: log #" + i.to_s + " may not have a valid IP Address (" + l.loc + ")" if !(IPAddr.new(l.loc) rescue false)
    for c in l.host.to_s.chars do
      if not HOSTNAME_VALID_CHARS.include? c then hostname_not_valid = true; cha = c end
    end
    puts "[LINT] WARN: log #" + i.to_s + " may not have a valid hostname (invalid char '" + cha + "')" if hostname_not_valid
  end
end


if $0 == __FILE__ then start(ARGV) end
