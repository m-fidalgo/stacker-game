require 'ruby2d'

BLOCK_AMOUNT = 4
BLOCK_COLOR = Color.new(['orange', 'yellow', 'green'].sample)
BLOCK_WIDTH = 7
BLOCK_HEIGHT = 20
FRAMES = 60
GRID_COLOR = Color.new('#222222')
GRID_SIZE = 40
INITIAL_SPEED = 4
LINE_WIDTH = 2
TEXT_SIZE = 40
TEXT_X_POS = 40
TEXT_Y_POS = 80
TEXT_X_OFFSET = 10
TEXT_Y_OFFSET = 50


def draw_grid
  (0..Window.width).step(GRID_SIZE).each do |x|
    Line.new(x1: x, x2: x, y1: 0, y2: Window.height, width: LINE_WIDTH, color: GRID_COLOR, z: 1)
  end

  (0..Window.height).step(GRID_SIZE).each do |y|
    Line.new(x1: 0, x2: Window.width, y1: y, y2: y, width: LINE_WIDTH, color: GRID_COLOR, z: 1)
  end
end

def draw_square(x:, y:)
  Square.new(x: x, y: y, color: BLOCK_COLOR, size: GRID_SIZE)
end

def draw_initial_blocks(current_line)
  (0..BLOCK_AMOUNT).map do |index|
    draw_square(x: GRID_SIZE * index, y: GRID_SIZE * current_line)
  end
end

def show_game_over(score)
  Text.new("Game over!", size: TEXT_SIZE, x: TEXT_X_POS, y: TEXT_Y_POS, z: 2)
  Text.new("Score: #{score}", size: TEXT_SIZE, x: TEXT_X_POS + TEXT_X_OFFSET, y: TEXT_Y_POS + TEXT_Y_OFFSET, z: 2)
end

def update_blocks(current_direction:, active_squares:)
  case current_direction
  when :right
    active_squares.each { |square| square.x += GRID_SIZE }
    if active_squares.last.x + active_squares.last.width >= Window.width
      current_direction = :left
    end
  when :left
    active_squares.each { |square| square.x -= GRID_SIZE }
    if active_squares.first.x <= 0
      current_direction = :right
    end
  end

  return current_direction, active_squares
end

def has_block(frozen_squares:, x:, y:)
  frozen_squares.has_key?("#{x},#{y}")
end

def draw_new_blocks(current_line:, active_squares:, frozen_squares:)
  active_squares.each do |active_square|
    x, y = active_square.x,  active_square.y
    first_line = BLOCK_HEIGHT - 2
    has_block_below = has_block(frozen_squares: frozen_squares, x: x, y: y + GRID_SIZE)

    if current_line == first_line || has_block_below
      frozen_squares["#{x},#{y}"] = draw_square(x: x, y: y)
    end
  end

  active_squares.each(&:remove)
  active_squares = []

  (0..BLOCK_WIDTH).each do |index|
    x, y = GRID_SIZE * index, GRID_SIZE * current_line

    if has_block(frozen_squares: frozen_squares, x: x, y: y + GRID_SIZE)
      active_squares.push(draw_square(x: x, y: y))
    end
  end

  return active_squares, frozen_squares
end

def main
  set width: BLOCK_WIDTH * GRID_SIZE,
      height: BLOCK_HEIGHT * GRID_SIZE

  current_line = BLOCK_HEIGHT - 1
  current_direction = :right
  speed = INITIAL_SPEED
  score = 0

  draw_grid
  frozen_squares = {}
  active_squares = draw_initial_blocks(current_line)

  update do
    if active_squares.empty?
      show_game_over(score)
    elsif Window.frames % (FRAMES / speed) == 0
      current_direction, active_squares = update_blocks(
        current_direction: current_direction,
        active_squares: active_squares
      )
    end
  end

  on :key_down do
    current_line -= 1
    speed += 1

    active_squares, frozen_squares = draw_new_blocks(
      current_line: current_line, 
      active_squares: active_squares,
      frozen_squares: frozen_squares
    )
    score = frozen_squares.size
  end

  show
end

main