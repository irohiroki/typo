desc "Setup Typo to run on Heroku"
task :heroku do
  root_path = File.expand_path(File.dirname(__FILE__) + "/../../")

  def gemfile
    File.open('.gems', 'w') do |f|
      f.puts "rails   --version '2.3.5'"
      f.puts "htmlentities"
      f.puts "calendar_date_select"
      f.puts "bluecloth   --version '~> 2.0.5'"
      f.puts "coderay   --version '~> 0.8'"
      f.puts "mislav-will_paginate  --source gems.github.com   --version '~> 2.3.11'"
      f.puts "RedCloth    --version '~> 4.2.2'"
      f.puts "panztel-actionwebservice    --version '2.3.5'"
      f.puts "addressable   --version '~> 2.1.0'"
      f.puts "mini_magick   --version '~> 1.2.5'"
    end
  end

  def preinitializer
    File.open('preinitializer.rb', 'w') do |f|
      f.puts "require 'fileutils'"
      f.puts "file_utils_no_write = FileUtils::NoWrite"
      f.puts "Object.send :remove_const, :FileUtils"
      f.puts "FileUtils = file_utils_no_write"
    end
  end

  Dir.chdir(root_path) do
    ["git init", "git add *", "git commit -m 'The typo package.'",
     "mkdir public/files", "mkdir -p tmp/cache",
    "touch public/files/.gitkeep", "touch tmp/cache/.gitkeep"].each do |cmd|
      system("#{cmd}")
    end
  end

  Dir.chdir("#{root_path}/config") do
    preinitializer
  end

  Dir.chdir(root_path) do
    ["git add *", "git commit -m 'Getting things setup for heroku'", "heroku create",
    "git push heroku master",].each do |cmd|
      system("#{cmd}")
    end
  end

  Dir.chdir(root_path) do
    ["git add .gems", "git commit -m 'added gems manifest file'",
    "git push heroku", "heroku rake db:migrate", "heroku open"].each do |cmd|
      gemfile
      system("#{cmd}")
    end
  end
end
