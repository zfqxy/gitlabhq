require 'spec_helper'

describe Gitlab::GithubImport::LabelFormatter, lib: true do
  let(:project) { create(:empty_project) }
  let(:raw) { double(name: 'improvements', color: 'e6e6e6') }

  subject { described_class.new(project, raw) }

  describe '#attributes' do
    it 'returns formatted attributes' do
      expect(subject.attributes).to eq({
        project: project,
        title: 'improvements',
        color: '#e6e6e6'
      })
    end
  end

  describe '#create!' do
    context 'when label does not exist' do
      it 'creates a new label' do
        expect { subject.create! }.to change(Label, :count).by(1)
      end
    end

    context 'when label exists' do
      it 'does not create a new label' do
        project.labels.create(name: raw.name)

        expect { subject.create! }.not_to change(Label, :count)
      end
    end
  end
end
