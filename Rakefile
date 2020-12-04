task :run, [:day] do |t, args|
  puts "### Running #{args[:day]}.rb ###"
  system "bundle exec ruby -r./lib/prelude.rb -Ilib/ solutions/#{args[:day]}.rb"
  puts
end

task :new, [:day] do |t, args|
  puts "Creating #{args[:day]}.rb"
  system "touch solutions/#{args[:day]}.rb"
  system "touch data/#{args[:day]}.txt"
end


task :run_all do
  (1..25).each do |day|
    #uuuuuugly but functional.
    if File.exists?("solutions/day#{day}.rb")
      system "rake run[day#{day}]"
    end
  end
end

