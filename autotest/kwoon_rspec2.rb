require 'autotest/rspec2'

class Autotest::KwoonRspec2 < Autotest::Rspec2
  # Fix a bug in RSpec 2.0.0.rc
  # http://github.com/rspec/rspec-core/issues/issue/178
  def consolidate_failures(failed)
    filters = new_hash_of_arrays
    failed.each do |spec, trace|
      # if trace =~ /(.*spec\.rb)/
      if trace =~ /(.*\.rb)/
        filters[$1] << spec
      end
    end
    return filters
  end
end

class Git
  def commit(message, options = { })
    puts "*** Committing (#{message})"
    system "git add ."
    system "git commit -am '#{message}' #{"--allow-empty" if options[:allow_empty]}"
    puts "*** Finished committing"
    puts
  end
end

git = Git.new

Autotest.add_hook(:initialize) do
  git.commit("Starting", :allow_empty => true)
end

Autotest.add_hook(:red) do
  git.commit("Red", :allow_empty => true)
end

Autotest.add_hook(:green) do
  git.commit("Green")
end

Autotest.add_hook(:all_good) do
  git.commit("All good", :allow_empty => true)
end

Autotest.add_hook(:quit) do
  git.commit("Stopping", :allow_empty => true)
end