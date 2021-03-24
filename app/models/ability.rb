# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :me, User do |profile_owner|
      profile_owner.id == user.id
    end

    can :create, [Question, Answer, Comment]

    can [:update, :destroy], [Question, Answer] do |resource|
      user.author?(resource)
    end
    
    can :best, Answer do |answer|
      user.author?(answer.question)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.author?(file.record)
    end

    can :destroy, Link do |link|
      user.author?(link.linkable)
    end

    can [:vote_for, :vote_against, :unvote], [Question, Answer] do |votable|
      !user.author?(votable)
    end
  end
end
