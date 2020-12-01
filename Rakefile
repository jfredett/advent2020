task :run, [:day] do |t, args|
  puts "Running #{args[:day]}.rb"
  system "bundle exec ruby -Ilib/ solutions/#{args[:day]}.rb"
end

task :new, [:day] do |t, args|
  puts "Creating #{args[:day]}.rb"
  system "touch solutions/#{args[:day]}.rb"
  system "tough data/#{args[:day]}.txt"
end

