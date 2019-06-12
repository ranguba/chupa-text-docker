# -*- ruby -*-

version_key = "CHUPA_TEXT_DOCKER_VERSION"
dockerfile_paths = [
  "chupa-text/ubuntu/Dockerfile",
  "chupa-text/debian/Dockerfile",
]
dockerfile_content = File.read(dockerfile_paths[0])
/#{version_key}=(.+?)$/ =~ dockerfile_content
version = $1

task :default => :run

desc "Build images"
task :build do
  cd("proxy") do
    sh("docker", "build", "-t", "ranguba/chupa-text:proxy", ".")
  end
  cd("chupa-text") do
    sh("docker", "build", "-t", "ranguba/chupa-text:latest", ".")
  end
end

desc "Run"
task :run => :build do
  sh("docker-compose", "up")
end

namespace :version do
  desc "Bump version"
  task :bump do
    new_version = ENV["VERSION"]
    raise "No ENV['VERSION']" if new_version.nil?
    dockerfile_paths.each do |dockerfile_path|
      dockerfile_content = File.read(dockerfile_path)
      new_dockerfile_content =
        dockerfile_content
          .gsub(/#{version_key}=.+?$/,
                "#{version_key}=#{new_version}")
      File.open(dockerfile_path, "w") do |dockerfile|
        dockerfile.print(new_dockerfile_content)
      end
    end
  end
end

desc "Tag #{version}"
task :tag do
  sh("git", "tag",
     "-a", version,
     "-m", "#{version} has been released!!!")
  sh("git", "push", "--tags")
end

desc "Release #{version}"
task :release => :tag
