require 'rails_helper'

RSpec.describe Event, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @event = FactoryBot.build(:event, user: @user)
    @event_today = FactoryBot.create(:event, user: @user, date: Date.today)
    @event_future = FactoryBot.create(:event, user: @user, date: Date.tomorrow)
    @event_past = FactoryBot.create(:event, user: @user, date: Date.yesterday)
  end

  describe 'イベント新規登録' do
    context '登録できるとき' do
      it '全ての項目が存在すれば登録できる' do
        expect(@event).to be_valid
      end
    end

    context '登録できないとき' do
      it 'タイトルが空では登録できない' do
        @event.title = ''
        @event.valid?
        expect(@event.errors.full_messages).to include("Title can't be blank")
      end

      it '日付が空では登録できない' do
        @event.date = nil
        @event.valid?
        expect(@event.errors.full_messages).to include("Date can't be blank")
      end

      it '場所が空では登録できない' do
        @event.location = ''
        @event.valid?
        expect(@event.errors.full_messages).to include("Location can't be blank")
      end

      it '詳細が空では登録できない' do
        @event.description = ''
        @event.valid?
        expect(@event.errors.full_messages).to include("Description can't be blank")
      end

      it 'ユーザーが紐づいていないと登録できない' do
        @event.user = nil
        @event.valid?
        expect(@event.errors.full_messages).to include("User must exist")
      end

      describe 'スコープの動作' do
    it 'upcoming は今日以降の試合を取得する' do
      expect(Event.upcoming).to include(@event_today, @event_future)
      expect(Event.upcoming).not_to include(@event_past)
    end

    it 'past は過去の試合を取得する' do
      expect(Event.past).to include(@event_past)
      expect(Event.past).not_to include(@event_future)
    end

    it 'this_month は当月の試合を取得する' do
      event_next_month = FactoryBot.create(:event, user: @user, date: Date.today.next_month.beginning_of_month)
      expect(Event.this_month).to include(@event_today)
      expect(Event.this_month).not_to include(event_next_month)
    end
  end

  describe 'インスタンスメソッドの動作' do
    it '#past? は過去のイベントなら true を返す' do
      expect(@event_past.past?).to be true
      expect(@event_future.past?).to be false
    end

    it '#this_month? は今月のイベントなら true を返す' do
      expect(@event_today.this_month?).to be true
      event_next_month = FactoryBot.build(:event, date: Date.today.next_month)
      expect(event_next_month.this_month?).to be false
    end

    it '#attendance_summary は出欠状況をハッシュで返す' do
      FactoryBot.create(:attendance, event: @event_today, user: @user, status: :attending)
      summary = @event_today.attendance_summary

      expect(summary).to include(:attending, :pending, :absent, :total_members, :responded, :not_responded)
      expect(summary[:attending]).to eq(1)
    end

    it '#attendance_status_for(user) はユーザーの出欠を返す' do
      FactoryBot.create(:attendance, event: @event_today, user: @user, status: :pending)
      expect(@event_today.attendance_status_for(@user)).to eq('pending')
      end
    end
  end
end
end
