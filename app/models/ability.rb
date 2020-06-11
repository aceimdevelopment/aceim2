# frozen_string_literal: true


# PARA AUTORIZAR ACCESO A ACCIONES DE CONTROLADORES COLOCAR LA SIGUIENTE LINEA EN EL CONTROLADOR RESPECTIVO:
# load_and_authorize_resource

class Ability
  include CanCan::Ability

  def initialize(user)

    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    # all_visible = [Course, CoursePeriod, Bank, Career, Agreement, BankAccount, Student, Instructor, Language, Level, Period, Section, AcademicRecord, User]

    if user.administrator?
        can :access, :rails_admin
        can :manage, :dashboard
        if user.administrator.desarrollador?
            can :manage, :all
        # elsif user.administrator.administrativo?
        # Agregar vista de Guedez y Mendez
        elsif user.administrator.superadmin?
            can :manage, [CoursePeriod, Career, Student, Instructor, Section, AcademicRecord, User]
            can :read, [Bank, Language, Level, Course, Period, CoursePeriod, Agreement]
            can :update, [Bank, Language, Level, Course, Period, CoursePeriod, Agreement]
            can :create, [Bank, Period, CoursePeriod, Agreement]
            # cannot :destroy, [Bank, Language, Level, Course, Period, CoursePeriod, Agreement]

        elsif user.administrator.supervidor?
            can :read, [AcademicRecord, Student, Section]
        else
            can :read, [CoursePeriod, AcademicRecord, Student]
        end
        #     can :read, [Administrator]
        # elsif user.administrator.supervisor
        #     can :create, [Student, Instructor, User]
        #     can :update, [Student, Instructor, User, AcademicRecord]
        #     cannot :destroy, [Student, Instructor, User]
        #     can :read, [Course, CoursePeriod, Career]
        # else
        #     can :read, [Course, CoursePeriod, Career, Student, Instructor, AcademicRecord]
        # end

    end

    # can :manage, :dashboard 
    # can :manage, [User]
    # can :manage, :all

    # if user.superadmin_role?
    #   can :manage, :all
    #   can :access, :rails_admin       # only allow admin users to access Rails Admin
    #   can :manage, :dashboard         # allow access to dashboard
    # end
    # if user.supervisor_role?
    #   can :manage, User
    # end
    #   if user.superadmin_role?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
