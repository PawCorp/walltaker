require 'rake'

Rails.app_class.load_tasks

class PornBotJob
  def perform
    Rake::Task['walltaker:porn_bot_round'].execute
  end
end

class KiJob
  def perform
    Rake::Task['walltaker:ki_round'].execute
  end
end


class WarrenJob
  def perform
    Rake::Task['walltaker:warren_round'].execute
  end
end


class TaylorJob
  def perform
    Rake::Task['walltaker:taylor_round'].execute
  end
end

Crono.perform(PornBotJob).every 11.minutes
Crono.perform(KiJob).every 8.minutes
Crono.perform(WarrenJob).every 8.minutes
Crono.perform(TaylorJob).every 8.minutes
