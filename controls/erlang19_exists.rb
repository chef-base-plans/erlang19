title 'Tests to confirm erlang19 exists'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'erlang19')

control 'core-plans-erlang19-exists' do
  impact 1.0
  title 'Ensure erlang19 exists'
  desc '
  Verify erlang19 by ensuring its
  (1) binaries exist and
  (2) are executable'
  
  plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end

  [
    "ct_run",
    "dialyzer",
    "epmd",
    "erl",
    "erlc",
    "escript",
    "run_erl",
    "to_erl",
    "typer",
  ].each do |binary_name|
    command_full_path = File.join(plan_installation_directory.stdout.strip, "bin", binary_name)
    describe file(command_full_path) do
      it { should exist }
      it { should be_executable }
    end
  end
end
