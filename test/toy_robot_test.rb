require 'test_helper'

class ToyRobotTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ToyRobot::VERSION
  end

  class RobotTest < Minitest::Test
    def described_class
      ToyRobot::Robot
    end

    def setup
      table = Array.new(5) { Array.new(5) { '.' } }
      @subject = described_class.new(table)
    end

    class DescribeMethods < RobotTest
      def test_subject_responds_to_facing
        assert_respond_to(@subject, :facing)
      end

      def test_subject_responds_to_move
        assert_respond_to(@subject, :move)
      end

      def test_subject_responds_to_left
        assert_respond_to(@subject, :left)
      end

      def test_subject_responds_to_right
        assert_respond_to(@subject, :right)
      end

      def test_subject_responds_to_place
        assert_respond_to(@subject, :place)
      end

      def test_subject_responds_to_report
        assert_respond_to(@subject, :report)
      end

      def test_subject_responds_to_draw
        assert_respond_to(@subject, :draw)
      end
    end

    class DescribedRobotInitializedAttributes < RobotTest
      def test_facing_has_default_value
        assert_equal "NORTH", @subject.facing
      end

      def test_position_has_default_value_x
        assert_equal 0, @subject.y
      end

      def test_position_has_default_value_y
        assert_equal 0, @subject.x
      end

      def test_report_default_value
        $stdout = StringIO.new
        @subject.report
        assert_equal "0,0,NORTH\n", $stdout.string
      ensure
        $stdout = STDOUT
      end
    end

    class DescribeRobotCommandMethods < RobotTest
      def test_move
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        subject.move

        assert_equal 0, subject.x
        assert_equal 1, subject.y
        assert_equal "NORTH", subject.facing
      end

      def test_move_multiple_times
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        3.times.each { subject.move }

        assert_equal 0, subject.x
        assert_equal 3, subject.y
        assert_equal "NORTH", subject.facing
      end

      def test_left
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        subject.left
        assert_equal "WEST", subject.facing
      end

      def test_left_twice_faces_south
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        2.times.each { subject.left }
        assert_equal "SOUTH", subject.facing
      end

      def test_left_three_times_faces_east
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        3.times.each { subject.left }
        assert_equal "EAST", subject.facing
      end

      def test_left_four_times_faces_north
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        4.times.each { subject.left }
        assert_equal "NORTH", subject.facing
      end

      def test_right
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        subject.right
        assert_equal "EAST", subject.facing
      end

      def test_right_twice_faces_south
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        2.times.each { subject.right }
        assert_equal "SOUTH", subject.facing
      end

      def test_right_three_times_faces_west
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        3.times.each { subject.right }
        assert_equal "WEST", subject.facing
      end

      def test_right_four_times_faces_north
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        4.times.each { subject.right }
        assert_equal "NORTH", subject.facing
      end

      def test_place
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        subject.place(0, 0, "NORTH")

        assert_equal 0, subject.x
        assert_equal 0, subject.y
        assert_equal "NORTH", subject.facing
      end

      def test_place_new_position
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        subject.place(1, 1, "NORTH")

        assert_equal 1, subject.x
        assert_equal 1, subject.y
        assert_equal "NORTH", subject.facing
      end

      def test_place_invalid_position
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        subject.place(-1, -1, "NORTH")

        assert_equal(-1, subject.x)
        assert_equal(-1, subject.y)
        assert_equal "NORTH", subject.facing
      end

      # The initial brief describes:
      # > The application should discard all commands in the sequence until a
      # > valid PLACE command has been executed.
      #
      # But does not mentioned that a PLACE command can be invalid or should
      # warn the user if it is invalid
      def test_invalid_placed_robot_does_not_move
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        subject.place(-1, -1, "NORTH")
        subject.move

        assert_equal(-1, subject.x)
        assert_equal(-1, subject.y)
        assert_equal "NORTH", subject.facing
      end

      def test_report_with_new_position_and_facing
        table = Array.new(5) { Array.new(5) { '.' } }
        subject = described_class.new(table)
        subject.place(4, 3, "SOUTH")

        $stdout = StringIO.new
        subject.report
        assert_equal "4,3,SOUTH\n", $stdout.string
      ensure
        $stdout = STDOUT
      end
    end
  end
end
