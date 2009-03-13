# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{slow-actions}
  s.version = "0.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Gauthier"]
  s.date = %q{2009-03-13}
  s.default_executable = %q{slow-actions}
  s.description = %q{TODO}
  s.email = %q{nick@smartlogicsolutions.com}
  s.executables = ["slow-actions"]
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["VERSION.yml", "README.rdoc", "bin/slow-actions", "lib/slow_actions_controller.rb", "lib/slow_actions_action.rb", "lib/slow_actions_parser.rb", "lib/slow_actions_log_entry.rb", "lib/slow_actions.rb", "lib/slow_actions_session.rb", "lib/slow_actions_computation_module.rb", "test/test_helper.rb", "test/data", "test/data/development.log", "test/data/production.recent.log", "test/slow_actions_benchmark_test.rb", "test/slow_actions_test.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/ngauthier/slow-actions}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
