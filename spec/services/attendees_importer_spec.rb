# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttendeesImporter do
  let(:event) { create :event, name: 'No Country for Old Men' }
  let(:fake_file) { instance_double('ActionDispatch::Http::UploadedFile', original_filename: 'fake file') }

  subject { AttendeesImporter.new(event, fake_file) }

  describe '#call' do
    context 'valid data' do
      before do
        allow(subject).to receive(:data).and_return(input_data)
      end

      let(:input_data) do
        [
          { name: 'Llewelyn Moss', email: 'one@example.com' },
          { name: 'Anton Chigurh', email: 'two@example.com' },
          { name: 'Carson Wells', email: 'three@example.com' }
        ]
      end

      it 'creates new attendees records' do
        expect { subject.call }.to change(Attendee, 'count').from(0).to(3)
      end

      it "doesn't create new attendee if such record exists" do
        event.attendees.create!(input_data)
        expect { subject.call }.to_not change(Attendee, 'count')
      end

      it 'binds attendees to event' do
        expect { subject.call }.to \
          change { event.reload.attendees.count }.from(0).to(3)
      end

      it 'replaces existing attendees from event' do
        tommy_lee_jones = event.attendees.create!(name: 'Sheriff E. T. Bell', email: 'email@email.email')
        event.attendees << tommy_lee_jones

        subject.call
        expect(event.reload.attendees).to_not include(tommy_lee_jones)
      end
    end

    context 'wrong input data' do
      context 'worng file format' do
        let(:input_data) { "fake input data" }

        before do
          allow(SmarterCSV).to receive(:process).and_raise('Wrong file format')
        end

        it 'returns nil' do
          x = subject.call
          expect(x).to be_nil
        end

        it 'contains the error' do
          subject.call
          expect(subject.errors).to \
            contain_exactly(a_hash_including(message: /Processing csv file error/))
        end
      end

      [:email, :name].each do |absent_field|
        context "#{absent_field} absence" do
          before do
            input_data.first[absent_field] = nil
            allow(subject).to receive(:data).and_return(input_data)
            Attendee.delete_all
          end

          let(:input_data) do
            [{ name: 'Fishka Bob', email: 'fishka.bob@mail.ru' }]
          end

          it "doesn't create new attendee" do
            expect { subject.call }.to_not change(Attendee, 'count').from(0)
          end
        end
      end
    end
  end
end
