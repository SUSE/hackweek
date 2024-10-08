class Ability
  # The first argument to `can` is the action you are giving the user
  # permission to do.
  # If you pass :manage it will apply to every action. Other common actions
  # here are :read, :create, :update and :destroy.
  #
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
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user
      # Everyone can:
      can :read, Project
      can :read, Keyword
      can :read, User
      can :read, Announcement
      can :read, Faq
      can %i[join leave like dislike create], Project
      can %i[originated likes opportunities], User
      can [:enroll], Announcement
      # ...change things they own
      can %i[update add_keyword delete_keyword], User, id: user.id
      can :read, Update, author_id: user.id
      can :manage, Project, originator_id: user.id
      can %i[create update], Comment, commenter_id: user.id
      can %i[update add_keyword delete_keyword advance recess add_episode delete_episode],
          Project do |project|
        project.users.include? user
      end

      # Organizers can:
      if user.role? :organizer
        can :manage, Announcement
        can :manage, Faq
      end

      # Admins can:
      can :manage, :all if user.role? :admin
    end
  end
end
