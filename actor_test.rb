require 'minitest/autorun'
require_relative 'actor.rb'

class ActorTest < MiniTest::Unit::TestCase
  
  def test_actor_is_instance_of_actor
    actor = Actor.new([0,1])
    actor.must_be_instance_of Actor
  end
  
  def test_actor_has_assigned_position
    actor = Actor.new([0,0])
    actor.position.must_equal [0,0]
  end
  
  def test_position_must_be_instance_of_array
    actor = Actor.new([0,0])
    actor.position.must_be_instance_of Array
  end
  
  def test_move
    actor = Actor.new([0,0], [10, 10])
    actor.move([2, 1])
    actor.position.must_equal [2, 1]
  end
  
  def test_featured
    actor = Actor.new([0,0], [10,10], true)
    assert(actor.featured, true)
  end
  
  def test_knows_environment_bounds
    actor = Actor.new([0,0], [10, 10])
    actor.env_bounds.must_equal [10, 10]
  end
  
  def test_move_random
    actor = Actor.new([5,5], [10, 10])
    actor.move_random
  end
  
  def test_move_random_is_one_step
    actor = Actor.new([0,0], [10, 10])
    first_position = actor.position
    actor.move_random
    # make sure neither direction moves more than |1| space 
    (first_position <=> actor.position).abs.must_be :<=, 1
  end
  
  # An out of bounds random move is currently blocked by the in_bounds checker on `move`.
  def test_move_random_in_bounds_min
    actor = Actor.new([0,0], [10, 10])
    print actor.position
    actor.move_random
    print actor.position
    actor.position[0].must_be :>=, 0
    actor.position[1].must_be :>=, 0
  end
  
  def test_move_random_in_bounds_max
    actor = Actor.new([0,0], [10, 10])
    actor.move_random
    actor.position[0].must_be :<, 10
    actor.position[1].must_be :<, 10
  end
  
  # We can only move one step at a time, so if we hit the wall (by trying to go over it), we just stay where we were.
  def test_cannot_move_out_of_bounds_max
    actor = Actor.new([9,9], [10, 10])
    actor.move([9,10])
    actor.position.must_equal [9, 9]
  end
  
  # Min is assumed to be 0
  def test_cannot_move_out_of_bounds_min
    actor = Actor.new([0,0], [10, 10])
    actor.move([-1, 0])
    actor.position.must_equal [0, 0]
    actor.move([-1, -1])
    actor.position.must_equal [0, 0]
  end
  
  def test_goal
    # This actor needs to move diagonally from top left to lower right
    actor = Actor.new([0,0], [10, 10])
    actor.goal = [10, 10]
    actor.goal.must_equal [10,10]
  end
  
  def test_log_moves
    actor = Actor.new([0,0], [10, 10])
    actor.move([0,1])
    actor.move([1,1])
    actor.moves.must_equal [[0,0], [0, 1], [1,1]]
  end
  
  def test_fitness_is_zero_on_init
    actor = Actor.new([0,0], [10, 10])
    actor.fitness.must_equal 0
  end
  
  def test_fitness_increase_with_each_move
    actor = Actor.new([0,0], [10, 10])
    actor.move([0,1])
    actor.move([1,1])
    actor.fitness.must_equal 2
  end
  
  def test_fitness_increase_with_random_move
    actor = Actor.new([0,0], [10, 10])
    actor.move_random
    actor.fitness.must_equal 1
  end
end