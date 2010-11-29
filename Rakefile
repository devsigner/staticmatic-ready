#change these values if you deploy with rsync
ssh_user      = "user@host.com"    # for rsync deployment
remote_root = "~/document_root/" # for rsync deployment

source = "src"  #source directory (needed to auto-rebuild site on changes)

desc "Runs preview"
task :preview do
  system "compass watch . &"
  system "staticmatic preview ."
end

desc "Builds the site"
task :build => 'styles:clear' do
  puts "*** Building the site ***"
  system "staticmatic build ."
end

desc "Clears and generates new styles, builds and deploys"
task :deploy => [:build, :push] do
  puts "*** Deploying the site ***"
  
end

desc "push"
task :push do
  system("rsync -avz --delete site/ #{ssh_user}:#{remote_root}")
end

namespace :styles do
  desc "Clears the styles"
  task :clear do
    puts "*** Clearing styles ***"
    system "rm -Rfv site/stylesheets/*"
  end
  
  desc "Generates new styles"
  task :generate do
    puts "*** Generating styles ***"
    system "compass compile"
  end
  
end

def rebuild_site(relative)
  puts "\n\n>>> Change Detected to: #{relative} <<<"
  if (relative.include? ".sass") || (relative.include? ".scss")
    IO.popen('rake styles:generate'){|io| print(io.readpartial(512)) until io.eof?}
    puts '>>> Update Styles Complete <<<'
  else
    IO.popen('rake build'){|io| print(io.readpartial(512)) until io.eof?}
    puts '>>> Update Site Complete <<<'
  end
end

def rebuild_style(relative)
  puts "\n\n>>> Change Detected to: #{relative} <<<"
  IO.popen('rake styles:generate'){|io| print(io.readpartial(512)) until io.eof?}
  puts '>>> Update Complete <<<'
end

desc "Watch the site and regenerate when it changes"
task :watch do
  require 'fssm'
  puts ">>> Watching for Changes <<<"
  FSSM.monitor do
    path "#{File.dirname(__FILE__)}/#{source}" do
      update {|base, relative| rebuild_site(relative)}
      delete {|base, relative| rebuild_site(relative)}
      create {|base, relative| rebuild_site(relative)}
    end
  end
end