require 'rails_helper'

RSpec.describe Event, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @event = FactoryBot.build(:event, user: @user)
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
    end
  end
end
