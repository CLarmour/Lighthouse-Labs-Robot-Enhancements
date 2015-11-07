
class Robot
  
  attr_accessor :position, :items, :full_load, :health, :equipped_weapon

  def initialize
    @position = [0,0]
    @items = []
    @full_load = 250
    @health = 100
    @equipped_weapon = nil
  end

  def within_range?(bad_guy)
    if ((bad_guy.position[1] - @position[1]).abs <= 1) && ((bad_guy.position[0] - @position[0]).abs <= 1)
      true
    else
      false
    end
  end

  def within_grenade_range?(bad_guy)
    if ((bad_guy.position[1] - @position[1]).abs <= 2) && ((bad_guy.position[0] - @position[0]).abs <= 2)
      true
    else
      false
    end
  end

  def heal!
    if @health <= 0
      raise RobotAlreadyDeadError
      puts "This robot is dead and cannot be brought back to life"
    else
      @health += health_boost
      @health = 100 if @health > 100
    end
  end

  def wound(attack_amount)
    @health -= attack_amount
    @health = 0 if health < 0
  end

  def heal(health_boost)
    @health += health_boost
    @health = 100 if @health > 100
  end

  def grenade_attack(bad_guy)
    if within_grenade_range?(bad_guy)
      @equipped_weapon.hit(bad_guy)
    end
    @equipped_weapon = nil
  end

  def attack(bad_guy)
    @grenade_attack(bad_guy) if @equipped_weapon.is_a? (Grenade)
    if within_range?(bad_guy)
      @equipped_weapon ? @equipped_weapon.hit(bad_guy) : bad_guy.wound(5)
  end

  def items_weight
    @items.reduce(0) {|result, a| result += a.weight}
  end

  def move_left
    @position[0] -= 1
  end

  def move_right
    @position[0] += 1
  end

  def move_up
    @position[1] += 1
  end

  def move_down
    @position[1] -= 1
  end

  def auto_heal(item)
    if (@health <= 80) && (item.is_a? BoxOfBolts)
      item.feed(self) 
    end
  end

  def pick_up(item)
    if (items_weight + item.weight) <= @full_load
      auto_heal(item)
      @equipped_weapon = item if item.is_a? Weapon
    @items << item
    end
  end

end
