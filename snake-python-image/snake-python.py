import pygame
import random
import sys

# initialize pygame
pygame.init()

# screen size
WIDTH, HEIGHT = 800, 600
GRID = 20

screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Snake Game Nishant Sharma")

clock = pygame.time.Clock()
font = pygame.font.SysFont("Segoe UI", 32, bold=True)

# snake setup
snake = [(100, 100)]
snake_dir = (GRID, 0)
max_cells = 4

# apple setup
apple = (300, 300)

def get_random_position():
    return (random.randrange(0, WIDTH // GRID) * GRID,
            random.randrange(0, HEIGHT // GRID) * GRID)

def draw_background_text():
    big_font = pygame.font.SysFont("Arial", WIDTH // 10, bold=True, italic=True)
    text_surface = big_font.render("Nishant Sharma", True, (200, 200, 200))
    text_surface.set_alpha(30)  # transparent
    text_rect = text_surface.get_rect(center=(WIDTH // 2, HEIGHT // 2))
    screen.blit(text_surface, text_rect)

def game_over():
    global snake, snake_dir, max_cells, apple
    snake = [(100, 100)]
    snake_dir = (GRID, 0)
    max_cells = 4
    apple = get_random_position()

while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_LEFT and snake_dir != (GRID, 0):
                snake_dir = (-GRID, 0)
            elif event.key == pygame.K_RIGHT and snake_dir != (-GRID, 0):
                snake_dir = (GRID, 0)
            elif event.key == pygame.K_UP and snake_dir != (0, GRID):
                snake_dir = (0, -GRID)
            elif event.key == pygame.K_DOWN and snake_dir != (0, -GRID):
                snake_dir = (0, GRID)

    # move snake
    new_head = ((snake[0][0] + snake_dir[0]) % WIDTH,
                (snake[0][1] + snake_dir[1]) % HEIGHT)
    snake.insert(0, new_head)

    if len(snake) > max_cells:
        snake.pop()

    # check collision with apple
    if snake[0] == apple:
        max_cells += 1
        apple = get_random_position()

    # check collision with self
    if snake[0] in snake[1:]:
        game_over()

    # draw everything
    screen.fill((255, 255, 255))
    draw_background_text()

    # draw apple
    pygame.draw.rect(screen, (255, 0, 0), (apple[0], apple[1], GRID - 1, GRID - 1))

    # draw snake
    for x, y in snake:
        pygame.draw.rect(screen, (0, 200, 0), (x, y, GRID - 1, GRID - 1))

    # heading text
    heading = font.render("Snake Game Nishant Sharma", True, (255, 255, 255))
    heading_rect = heading.get_rect(center=(WIDTH // 2, 20))
    screen.blit(heading, heading_rect)

    pygame.display.flip()
    clock.tick(10)
