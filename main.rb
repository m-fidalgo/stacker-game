require 'ruby2d'

BLOCK_WIDTH = 7
BLOCK_HEIGHT = 20
GRID_COLOR = Color.new('#222222')
GRID_SIZE = 40
LINE_WIDTH = 2

def draw_grid
  (0..Window.width).step(GRID_SIZE).each do |x|
    Line.new(x1: x, x2: x, y1: 0, y2: Window.height, width: LINE_WIDTH, color: GRID_COLOR)
  end

  (0..Window.height).step(GRID_SIZE).each do |y|
    Line.new(x1: 0, x2: Window.width, y1: y, y2: y, width: LINE_WIDTH, color: GRID_COLOR)
  end
end

def main
  set width: BLOCK_WIDTH * GRID_SIZE,
      height: BLOCK_HEIGHT * GRID_SIZE

  draw_grid
  show
end

main