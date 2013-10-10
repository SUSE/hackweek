class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user
      can :read, :all
      can [:join, :leave, :like, :dislike, :create], Project
      can :enroll, Announcement
      # FIXME: This should go away if we implement 
      # https://github.com/SUSE/hackweek/issues/33
      if user.id == 1
        can :manage, Announcement
      end

      can :manage, Project, :originator_id => user.id
      can :manage, User, :id => user.id

      can [:edit, :update, :add_keyword, :delete_keyword], Project do |project|
        project.users.include? user
      end

    end

    
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
