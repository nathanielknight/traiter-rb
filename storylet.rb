# TODO(nknight): In-place validations
# TODO(nknight): Abstraction?

class Storylet
  def initialize(id)
    @_id = id
    @_choice = []
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

  def fixed_choice(&blk)
    choice = FixedChoice.new
    choice.define(&blk)
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
end

class Requirements
  def initialize
    @_requirements = []
  end

  def define(&block)
    instance_eval(&block)
    self
  end

  def eq(quality, number: nil, text: nil)
    @_requirements.append(Requirement.new(quality, :eq, { number: number, text: text }))
  end

  def less_than(quality, number)
    @_requirements.append(Requirement.new(quality, :lt, number))
    # TODO(nknight): Other ops (lt, gt, lte, gte, eq, neq, set, unset)
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
