# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Attendee passwords', type: :request do
  describe 'GET /attendees/password/new' do
    it 'is disabled' do
      expect { get new_attendee_password_path }.to \
        raise_error(ActionController::RoutingError, 'Not Found')
    end
  end

  describe 'POST /attendees/password' do
    it 'is disabled' do
      expect { post attendee_password_path }.to raise_error(ActionController::RoutingError, 'Not Found')
    end
  end

  describe 'GET /attendees/password/edit' do
    subject(:send_request) do
      get edit_attendee_password_path, params: { reset_password_token: reset_token }
    end

    let!(:attendee) { create :attendee }
    let(:reset_token) { attendee.send(:set_reset_password_token) }

    it 'renders a successful response' do
      send_request
      expect(response).to be_successful
    end
  end

  describe 'PATCH /attendees/password' do
    context 'correct params' do
      subject(:send_request) { patch attendee_password_path, params: valid_params }

      let!(:attendee) { create :attendee, password: 'not_foobar' }
      let(:set_reset_password_token) { attendee.send(:set_reset_password_token) }
      let(:valid_params) do
        {
          attendee: {
            password: 'foobar',
            password_confirmation: 'foobar',
            reset_password_token: set_reset_password_token
          }
        }
      end

      it 'updates the password' do
        send_request
        expect(attendee.reload.valid_password?('foobar')).to be true
      end

      it 'resets the token' do
        set_reset_password_token
        initial_token = attendee.reset_password_token

        expect { send_request }.to \
          change { attendee.reload.reset_password_token }.from(initial_token).to(nil)
      end

      it "redirects to attendee's page" do
        send_request
        expect(response).to redirect_to(event_attendee_path(attendee.event_id, attendee))
      end
    end

    context 'wrong params' do
      subject(:send_request) do
        patch attendee_password_path, params: { attendee: wrong_params }
      end

      let!(:attendee) { create :attendee }
      let(:set_reset_password_token) { attendee.send(:set_reset_password_token) }
      let(:new_password) { 'foobar' }
      let(:wrong_params) do
        {
          password: new_password,
          password_confirmation: new_password,
          reset_password_token: set_reset_password_token
        }
      end

      context 'outdated token' do
        before do
          set_reset_password_token
          attendee.update!(reset_password_sent_at: 5.days.ago)
        end

        it 'rerenders the edit view and declares the error' do
          send_request
          expect(response.body).to include('Reset password token has expired, please request a new one')
        end

        it "doesn't update the password" do
          send_request
          expect(attendee.reload.valid_password?(new_password)).to be false
        end

        it "doesn't reset the token" do
          set_reset_password_token
          send_request
          expect(attendee.reload.reset_password_token).not_to be_nil
        end
      end

      context 'wrong token' do
        before do
          wrong_params.merge!(reset_password_token: '???????')
        end

        it 'rerenders the edit view and declares the error' do
          send_request
          expect(response.body).to include('Reset password token is invalid')
        end

        it "doesn't update the password" do
          send_request
          expect(attendee.reload.valid_password?(new_password)).to be false
        end

        it "doesn't reset the token" do
          set_reset_password_token
          send_request
          expect(attendee.reload.reset_password_token).not_to be_nil
        end
      end

      context 'short password' do
        let(:new_password) { '1234' }

        before do
          set_reset_password_token
        end

        it 'rerenders the edit view and declares the error' do
          send_request
          expect(response.body).to include('Password is too short')
        end

        it "doesn't update the password" do
          send_request
          expect(attendee.reload.valid_password?(new_password)).to be false
        end

        it "doesn't reset the token" do
          set_reset_password_token
          send_request
          expect(attendee.reload.reset_password_token).not_to be_nil
        end
      end

      context 'wrong confirmation' do
        before do
          wrong_params.merge!(password_confirmation: 'wrong_confirma')
        end

        it 'rerenders the edit view and declares the error' do
          send_request
          expect(response.body).to include('Password confirmation doesn&#39;t match Password')
        end

        it "doesn't update the password" do
          send_request
          expect(attendee.reload.valid_password?(new_password)).to be false
        end

        it "doesn't reset the token" do
          set_reset_password_token
          send_request
          expect(attendee.reload.reset_password_token).not_to be_nil
        end
      end
    end
  end
end
