require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @event = FactoryBot.create(:event, user: @user)
    @comment = FactoryBot.build(:comment, user: @user, event: @event)
  end

  describe 'コメント投稿' do
    context '投稿できるとき' do
      it 'content、user、eventがあれば投稿できる' do
        expect(@comment).to be_valid
      end
    end

    context '投稿できないとき' do
      it 'contentが空では投稿できない' do
        @comment.content = ''
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Content can't be blank")
      end

      it 'contentが200文字を超えると投稿できない' do
        @comment.content = 'あ' * 201
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Content is too long (maximum is 200 characters)')
      end

      it 'userが紐づいていないと投稿できない' do
        @comment.user = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('User must exist')
      end

      it 'eventが紐づいていないと投稿できない' do
        @comment.event = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Event must exist')
      end
    end
  end
end
