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

def draw_grid
  (0..Window.width).step(GRID_SIZE).each do |x|
    Line.new(x1: x, x2: x, y1: 0, y2: Window.height, width: LINE_WIDTH, color: GRID_COLOR, z: 1)
  end

  (0..Window.height).step(GRID_SIZE).each do |y|
    Line.new(x1: 0, x2: Window.width, y1: y, y2: y, width: LINE_WIDTH, color: GRID_COLOR, z: 1)
  end
end

def draw_initial_blocks(current_line)
  (0..BLOCK_AMOUNT).map do |index|
    Square.new(
      x: GRID_SIZE * index,
      y: GRID_SIZE * current_line,
      size: GRID_SIZE,
      color: BLOCK_COLOR,
    )
  end
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

def draw_frozen_squares(active_squares:, frozen_squares:)
  active_squares.each do |active_square|
    frozen_squares["#{active_square.x},#{active_square.y}"] = Square.new(
      x: active_square.x,
      y: active_square.y,
      color: BLOCK_COLOR,
      size: GRID_SIZE
    )
  end

  frozen_squares
end

def draw_new_blocks(current_line:, active_squares:, frozen_squares:)
  active_squares.each(&:remove)
  active_squares = []

  (0..BLOCK_WIDTH).each do |index|
    x = GRID_SIZE * index
    y = GRID_SIZE * current_line

    if frozen_squares.has_key?("#{x},#{y + GRID_SIZE}")
      active_squares.push(Square.new(
        x: x,
        y: y,
        color: BLOCK_COLOR,
        size: GRID_SIZE
      ))
    end
  end

  active_squares
end

def main
  set width: BLOCK_WIDTH * GRID_SIZE,
      height: BLOCK_HEIGHT * GRID_SIZE

  current_line = BLOCK_HEIGHT - 1
  current_direction = :right
  speed = INITIAL_SPEED

  draw_grid
  frozen_squares = {}
  active_squares = draw_initial_blocks(current_line)

  update do
    if Window.frames % (FRAMES / speed) == 0
      current_direction, active_squares = update_blocks(
        current_direction: current_direction,
        active_squares: active_squares
      )
    end
  end

  on :key_down do
    current_line -= 1
    speed += 1

    frozen_squares = draw_frozen_squares(
      active_squares: active_squares,
      frozen_squares: frozen_squares
    )
    active_squares = draw_new_blocks(
      current_line: current_line, 
      active_squares: active_squares,
      frozen_squares: frozen_squares
    )
  end
end

main
show