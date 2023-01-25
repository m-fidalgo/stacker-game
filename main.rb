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

def draw_blocks(current_line)
  (0..BLOCK_AMOUNT).map do |index|
    Square.new(
      x: GRID_SIZE * index,
      y: GRID_SIZE * current_line,
      size: GRID_SIZE,
      color: BLOCK_COLOR,
    )
  end
end

def update_blocks(current_direction:, speed:, active_squares:)
  update do
    if Window.frames % (FRAMES / speed) == 0
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
    end
  end
end

def main
  set width: BLOCK_WIDTH * GRID_SIZE,
      height: BLOCK_HEIGHT * GRID_SIZE

  current_line = BLOCK_HEIGHT - 1
  current_direction = :right
  speed = INITIAL_SPEED

  draw_grid
  active_squares = draw_blocks(current_line)
  update_blocks(
    current_direction: current_direction,
    speed: speed,
    active_squares: active_squares
  )

  show
end

main