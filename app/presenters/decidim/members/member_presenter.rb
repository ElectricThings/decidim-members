# frozen_string_literal: true

module Decidim
  module Members
    class MemberPresenter < Rectify::Presenter
      attribute :user, Decidim::User

      delegate :name, :avatar, :to_param, to: :user

      def languages
        if codes = profile_attr('languages')
          codes.map{ |l| LanguageList::LanguageInfo.find(l)&.name }.compact
        end
      end

      def areas_of_interest
        if areas = profile_attr('areas_of_interest')
          areas = areas.map{ |name| AreaOfInterest.for(name) }.compact
          if other = other_area_of_interest
            areas << other
          end
          areas
        end
      end

      def other_area_of_interest
        profile_attr('other_area_of_interest').presence
      end

      def country
        if country_code = profile_attr('country') and
           country = ISO3166::Country[country_code]

          country.translations[I18n.locale.to_s] || country.name
        end
      end

      def about_me
        profile_attr 'about_me'
      end

      private

      def profile_attr(name)
        user.profile[name] if user.profile
      end
    end
  end
end
