require 'rails_helper'

RSpec.describe Notice, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @notice = FactoryBot.build(:notice, user: @user)
  end

  describe 'お知らせ作成' do
    context '作成できるとき' do
      it 'titleとcontentとuserが存在すれば登録できる' do
        expect(@notice).to be_valid
      end
    end

    context '作成できないとき' do
      it 'titleが空では登録できない' do
        @notice.title = ''
        @notice.valid?
        expect(@notice.errors.full_messages).to include("Title can't be blank")
      end

      it 'contentが空では登録できない' do
        @notice.content = ''
        @notice.valid?
        expect(@notice.errors.full_messages).to include("Content can't be blank")
      end

      it 'userが紐づいていないと登録できない' do
        @notice.user = nil
        @notice.valid?
        expect(@notice.errors.full_messages).to include('User must exist')
      end
    end
  end
end
