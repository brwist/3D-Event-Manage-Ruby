# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/attendees', type: :request do
  before { sign_in create(:user, :admin) }

  let(:event) { create :event }

  describe 'POST /create' do
    subject(:send_request) do
      post event_attendees_path(event), params: { attendee: attendee_params }
    end

    let(:attendee_params) do
      { name: Faker::Name.name, email: Faker::Internet.email, password: '12345678' }
    end

    it_behaves_like 'authorization protected action'

    context 'valid params' do
      context 'attendee with specified params doesnt exist' do
        it 'creates new attendee record' do
          expect { send_request }.to change(Attendee, 'count').by(1)
        end

        it 'binds the record to the event' do
          send_request
          expect(Attendee.last.event_id).to eq(event.id)
        end

        it "specifies the attendee's password" do
          send_request
          attendee = Attendee.last
          expect(attendee.valid_password?(attendee_params[:password])).to be true
        end
      end

      context 'attendee already exists and belongs to considered event' do
        before { event.attendees.create!(attendee_params) }

        it "doesn't create new attendee" do
          expect { send_request }.not_to change(Attendee, 'count')
        end

        it 'responds with error message' do
          send_request
          expect(flash[:error]).to include('has already been taken')
        end
      end

      context 'attendee already exists and belongs to another event' do
        before do
          another_event = create :event
          another_event.attendees.create!(attendee_params)
        end

        it 'creates new attendee record' do
          expect { send_request }.to change(Attendee, 'count').by(1)
        end

        it 'binds the record to the event' do
          send_request
          expect(Attendee.last.event_id).to eq(event.id)
        end
      end
    end

    context 'invalid params' do
      let(:attendee_params) do
        { name: Faker::Name.name, email: Faker::Internet.email }
      end

      %i[name email].each do |field|
        context "#{field} is absent" do
          it "doesn't create new attendee" do
            attendee_params[field] = nil
            expect { send_request }.not_to change(Attendee, 'count')
          end

          it 'responds with error message' do
            attendee_params[field] = nil
            send_request
            expect(flash[:error]).to include("can't be blank")
          end
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    subject(:send_request) { delete event_attendee_url(event, attendee) }

    let(:event) { create :event }
    let!(:attendee) { create :attendee, event: event }

    it_behaves_like 'authorization protected action'

    it 'destroys the attendee' do
      expect { send_request }.to change(Attendee, 'count').by(-1)
    end

    it 'redirects to the event page' do
      send_request
      expect(response).to redirect_to(edit_event_url(event, tab: 'attendees'))
    end
  end
end
