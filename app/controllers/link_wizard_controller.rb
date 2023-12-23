class LinkWizardController < ApplicationController
  include Wicked::Wizard

  before_action :set_progress, only: %i[show]
  before_action :set_link, only: %i[show apply]
  before_action :authorize

  steps :intro, :summon, :control, :kinks, :gender, :surprise, :no_fun, :orgasmic_conclusion

  def show
    case step
    when :summon
      @link
    end
    render_wizard
  end

  def apply
    case step
    when :intro
      if params[:gooner] == 'true'
        @link.min_score = 10
        current_user.pervert = true
        current_user.mascot = :taylor
        current_user.save
      else
        @link.min_score = 50
      end

    when :summon
      if params[:impatient] == 'true'
        @link.min_score -= 10
      end

    when :control
      protection_level = (params[:protect] || '3').to_i
      @link.blacklist ||= ''

      @link.blacklist += ' nightmare_fuel nazi why' if protection_level > 1
      @link.blacklist += ' meme death body_horror gore scat' if protection_level > 2
      @link.blacklist += ' urine fart rape messy_diaper cursed_image vore pregnant' if protection_level > 3
      @link.blacklist += ' diapers humor joke icon blood pain sadism crossover obese what_has_science_done' if protection_level > 4

      @link.min_score += 5 * protection_level

    when :kinks
      @link.terms = params[:terms] || ''

    when :gender
      bl_genders = params[:blacklisted_genders].filter &:present?
      bl_parts = params[:blacklisted_parts].filter &:present?
      bl_sex = params[:blacklisted_sexualities].filter &:present?

      @link.blacklist += ' male_focus manly muscular' if bl_genders.include? 'male'
      @link.blacklist += ' female_focus girly' if bl_genders.include? 'female'
      @link.blacklist += ' genderfluid ambiguous_gender' if bl_genders.include? 'nonbinary'
      @link.blacklist += ' genderswap' if bl_genders.include? 'genderbends'
      @link.blacklist += ' penis' if bl_parts.include? 'cocks'
      @link.blacklist += ' pussy' if bl_parts.include? 'pussies'
      @link.blacklist += ' anus anal_penetration' if bl_parts.include? 'assholes'
      @link.blacklist += ' cloaca' if bl_parts.include? 'cloaca'

      @link.blacklist += ' male/male' if bl_sex.include?('gay') && bl_genders.include?('male')
      @link.blacklist += ' female/female' if bl_sex.include?('gay') && bl_genders.include?('female')

      @link.blacklist += ' male/female' if bl_sex.include?('straight')

    when :surprise
      @link.theme = params[:theme] || nil

    when :no_fun
      @link.friends_only = params[:friends_only] == 'true'
    end

    @link.save
    redirect_to next_wizard_path
  end

  def spawn_link
    link = Link.new
    link.user = current_user
    link.unfinished = true
    link.never_expires = true
    link.min_score = 0
    link.save
    redirect_to link_wizard_path(link_id: link.id, id: :intro)
  end

  def update
    @link.unfinished = true

    if @link.errors.count == 0
      @link.save
      redirect_to link_path @link
    else
      redirect_back_or_to link_wizard_path(link_id: link.id, id: :intro), alert: 'Something went wrong'
    end
  end

  private

  def set_link
    @link = Link.find(params['link_id'])

    unless @link
      redirect_to spawn_link_links_path
    end
  end

  def set_progress
    if wizard_steps.any? && wizard_steps.index(step).present?
      @progress = ((wizard_steps.index(step) + 1).to_d / wizard_steps.count.to_d) * 100
    else
      @progress = 0
    end
  end
end
