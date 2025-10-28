require 'rails_helper'

RSpec.describe Attendance, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @event = FactoryBot.create(:event, user: @user)
    @attendance = FactoryBot.build(:attendance, user: @user, event: @event)
  end

  describe '出欠登録' do
    context '登録できるとき' do
      it 'userとeventが紐づいていれば登録できる' do
        expect(@attendance).to be_valid
      end
    end

    context '登録できないとき' do
      it 'userがなければ登録できない' do
        @attendance.user = nil
        @attendance.valid?
        expect(@attendance.errors.full_messages).to include('User must exist')
      end

      it 'eventがなければ登録できない' do
        @attendance.event = nil
        @attendance.valid?
        expect(@attendance.errors.full_messages).to include('Event must exist')
      end
    end
  end

  describe 'enumの動作' do
    it 'statusの値が正しく定義されていること' do
      expect(Attendance.statuses).to eq({
        'undecided' => 0,
        'attending' => 1,
        'absent' => 2,
        'pending' => 3
      })
    end
  end
end
