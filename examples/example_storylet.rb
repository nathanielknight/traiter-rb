require_relative '../storylet'
require "json"

def storylet(id, &blk)
  s = Storylet.new(id)
  s.define(&blk)
  puts s.inspect
end

storylet(:foobaz) do
  body 'This is an example storylet'

  choice do
    requires do
      eq? 'Foo', text: '11'
    end
    description 'This is a choice; it always goes the same way.'
    outcome do
      body 'This describes the outcome of the action.'
      changes do
        gain 1, :xp
        set 'Stance', text: 'Defensive'
      end
      goto :foobaz
    end
  end

  check do
    requires do
      eq? 'Class', text: 'Druid'
    end
    description <<-EOF
        This is a check. It can succeed or based on a check of
        the player's qualities.
    EOF
    check 'Foobaz', 11
    success do
      body 'Ahah! It worked!'
      changes do
        gain 2, 'Gold'
        lose 1, 'Opportunity'
      end
      goto :start
    end
    failure do
      body "Shoot! It didn't work!"
      changes do
        lose 1, 'Opportunity'
      end
      goto :start
    end
  end

  risk do
    description 'This is a risk; it succeeds or fails based on chance.'
    requires do
      set? 'Class'
      eq? 'Religion', text: 'Samsonian'
    end
    success_chance = 0.5
    success do
      body 'Yay, it worked!'
      changes do
        gain 1, 'Fantasm'
      end
    end
    failure do
      body "Boo, it didn't work."
      changes do
        lose 2, 'Fantasm'
      end
    end
  end
end
