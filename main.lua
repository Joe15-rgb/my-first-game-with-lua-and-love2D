-- Dimensions de la fenêtre et de la grille
local largeur, hauteur = 600, 600
local grille = { {}, {}, {} }
local caseTaille = largeur / 3
local joueurActuel = "X"
local jeuTermine = false
local gagnant = nil

-- Initialisation de la grille vide
function initGrille()
  for i = 1, 3 do
    for j = 1, 3 do
      grille[i][j] = ""
    end
  end
  jeuTermine = false
  gagnant = nil
end

-- Fonction pour dessiner la grille
function love.draw()
  love.graphics.setLineWidth(5)

  -- Dessin des lignes
  for i = 1, 2 do
    love.graphics.line(i * caseTaille, 0, i * caseTaille, hauteur)
    love.graphics.line(0, i * caseTaille, largeur, i * caseTaille)
  end

  -- Dessin des X et O
  for i = 1, 3 do
    for j = 1, 3 do
      local x = (i - 1) * caseTaille + caseTaille / 2
      local y = (j - 1) * caseTaille + caseTaille / 2
      if grille[i][j] == "X" then
        love.graphics.setColor(1, 0, 0) -- Rouge
        love.graphics.line(x - 40, y - 40, x + 40, y + 40)
        love.graphics.line(x + 40, y - 40, x - 40, y + 40)
      elseif grille[i][j] == "O" then
        love.graphics.setColor(0, 0, 1) -- Bleu
        love.graphics.circle("line", x, y, 40)
      end
    end
  end

  -- Afficher le message de fin de partie
  if jeuTermine then
    love.graphics.setColor(1, 1, 1)
    if gagnant then
      love.graphics.print("Le joueur " .. gagnant .. " a gagné!", 200, 50, 0, 2, 2)
    else
      love.graphics.print("Match nul!", 250, 50, 0, 2, 2)
    end
  end
end

-- Fonction pour gérer les clics de souris
function love.mousepressed(x, y, button)
  if button == 1 and not jeuTermine then
    local colonne = math.floor(x / caseTaille) + 1
    local ligne = math.floor(y / caseTaille) + 1

    if grille[colonne][ligne] == "" then
      grille[colonne][ligne] = joueurActuel
      if verifierVictoire(joueurActuel) then
        gagnant = joueurActuel
        jeuTermine = true
      elseif grillePleine() then
        jeuTermine = true
      else
        joueurActuel = (joueurActuel == "X") and "O" or "X"
      end
    end
  elseif button == 1 and jeuTermine then
    initGrille()
  end
end

-- Vérifier si la grille est pleine
function grillePleine()
  for i = 1, 3 do
    for j = 1, 3 do
      if grille[i][j] == "" then
        return false
      end
    end
  end
  return true
end

-- Vérifier les conditions de victoire
function verifierVictoire(joueur)
  for i = 1, 3 do
    -- Vérifie les lignes et les colonnes
    if grille[i][1] == joueur and grille[i][2] == joueur and grille[i][3] == joueur then
      return true
    end
    if grille[1][i] == joueur and grille[2][i] == joueur and grille[3][i] == joueur then
      return true
    end
  end

  -- Vérifie les diagonales
  if grille[1][1] == joueur and grille[2][2] == joueur and grille[3][3] == joueur then
    return true
  end
  if grille[1][3] == joueur and grille[2][2] == joueur and grille[3][1] == joueur then
    return true
  end

  return false
end

-- Initialisation du jeu
function love.load()
  love.window.setMode(largeur, hauteur)
  initGrille()
end
