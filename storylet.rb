# TODO(nknight): In-place validations
# TODO(nknight): Abstraction?

class Storylet
  def initialize(id)
    @_id = id
    @_actions = []
  end

  def define(&block)
    instance_eval(&block)
    self
  end

  def title(t)
    @_title = t
  end

  def body(b)
    @_body = b
  end

  def choice(&blk)
    c = Choice.new
    c.define(&blk)
    @_actions.append(c)
  end

  def check(&blk)
    c = Check.new
    c.define(&blk)
    @_actions.append(c)
  end

  def risk(&blk)
    r = Risk.new
    r.define(&blk)
    @_actions.append(r)
  end
end

class Choice
  def description(d)
    @_description = d
  end

  def outcome(&blk)
    @_outcome = Outcome.new
    @_outcome.define(&blk)
  end

  def requires(&blk)
    @_requirements = Requirements.new
    @_requirements.define(&blk)
  end

  def define(&blk)
    instance_eval(&blk)
    self
  end
end

class Check < Choice
  undef_method :outcome

  def check(quality, target)
    @_target_quality = quality
    @_target_number = target
  end

  def success(&blk)
    @_success = Outcome.new
    @_success.define(&blk)
  end

  def failure(&blk)
    @_failure = Outcome.new
    @_failure.define(&blk)
  end
end

class Risk < Choice
  undef_method :outcome

  def success_chance(c)
    @_success_chance = c
  end

  def success(&blk)
    @_success = Outcome.new
    @_success.define(&blk)
  end

  def failure(&blk)
    @_failure = Outcome.new
    @_failure.define(&blk)
  end
end

class Outcome
  def body(b)
    @_body = b
  end

  def goto(id)
    @_goto = id
  end

  def changes(&blk)
    @_changes = Changes.new
    @_changes.define(&blk)
  end

  def define(&blk)
    instance_eval(&blk)
    self
  end
end

class Requirements
  def initialize
    @_requirements = []
  end

  def define(&block)
    instance_eval(&block)
    self
  end

  def eq?(quality, number: nil, text: nil)
    @_requirements.append(Requirement.new(quality, :eq, { number: number, text: text }))
  end

  def neq?(quality, number: nil, text: nil)
    @_requirements.append(Requirement.new(quality, :neq, { number: number, text: text }))
  end

  def set?(quality)
    @_requirements.append(Requirement.new(quality, :set))
  end

  def unset?(quality)
    @_requirements.append(Requirement.new(quality, :unset))
  end

  def lt?(quality, number)
    @_requirements.append(Requirement.new(quality, :lt, number))
  end

  def gt?(quality, number)
    @_requirements.append(Requirement.new(quality, :gt, number))
  end

  def gte?(quality, number)
    @_requirements.append(Requirement.new(quality, :gte, number))
  end

  def lte?(quality, number)
    @_requirements.append(Requirement.new(quality, :lte, number))
  end
end

Requirement = Struct.new(:quality, :op, :value)

class Changes
  def initialize
    @_changes = []
  end

  def define(&block)
    instance_eval(&block)
    self
  end

  def unset(q)
    @_changes.append(Change.new(:unset, q))
  end

  def set(q, text: nil, number: nil)
    @_changes.append(Change.new(:set, q, number, text))
  end

  def gain(a, q)
    @_changes.append(Change.new(:gain, q, a))
  end

  def lose(a, q)
    @_changes.append(Change.new(:lose, q, a))
  end
end

Change = Struct.new(:quality, :op, :number, :text)
