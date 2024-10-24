# frozen_string_literal: true

require "rails_helper"

RSpec.describe Pg::ClearQueryStatsJob, type: :job do
  let(:rake_task) { instance_double(Rake::Task) }

  before do
    allow(Rake::Task).to receive(:clear)
    allow(Rails.application).to receive(:load_tasks)
    allow(Rake::Task).to receive(:[]).with("pghero:clean_query_stats").and_return(rake_task)
    allow(rake_task).to receive(:invoke)
  end

  it "enqueues the job" do
    expect do
      described_class.perform_async
    end.to change(described_class.jobs, :size).by(1)
  end

  it "clears the Rake tasks" do
    described_class.new.perform
    expect(Rake::Task).to have_received(:clear)
  end

  it "loads the Rake tasks" do
    described_class.new.perform
    expect(Rails.application).to have_received(:load_tasks)
  end

  it "invokes the pghero clean query stats task" do
    described_class.new.perform
    expect(rake_task).to have_received(:invoke)
  end
end
