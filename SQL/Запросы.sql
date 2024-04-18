-- Названия предметов, цена и количество покупок, которые имеют Winrate выше 0.6, отсортированные по цене по убыванию.
SELECT Items.ItemName, Items.Price, ItemsStats.Purchases
FROM ItemsStats
JOIN Items ON ItemsStats.ItemName = Items.ItemName
WHERE ItemsStats.Winrate > 0.6
ORDER BY Items.Price DESC;

-- Имена героев, у которых место в топе ниже 60, и Winrate выше среднего, отсортированных по HeroesTop по убыванию.
SELECT CharacterName, HeroesTop, Winrate
FROM HeroesStats
WHERE HeroesTop < 60 AND Winrate > (SELECT AVG(Winrate) FROM HeroesStats)
ORDER BY HeroesTop ASC;

-- Никнеймы игроков и их Winrate среди тех, у кого победный процент выше среднего, отсортированных по Winrate по убыванию.
SELECT Nickname, Winrate
FROM Players
WHERE Winrate > (SELECT AVG(Winrate) FROM Players)
ORDER BY Winrate DESC;

-- Никнеймы игроков, у которых Winrate ниже среднего, и которые играли на персонажах с популярностью выше 80, отсортированные по Winrate по возрастанию.
SELECT p.Nickname, p.Winrate, h.Popularity
FROM Players p
JOIN Characters c ON p.Nickname = c.BestPlayerNickname
JOIN HeroesStats h ON c.CharacterName = h.CharacterName
WHERE p.Winrate < (SELECT AVG(Winrate) FROM Players) AND h.Popularity > 80
ORDER BY p.Winrate ASC;

-- Имена героев с их популярностью и частотой выбора , у которых популярность ниже 60 и Winrate выше 0.5, отсортированных по Popularity по убыванию.
SELECT CharacterName, Popularity, SelectFrequency
FROM HeroesStats
WHERE Popularity < 60 AND Winrate > 0.5
ORDER BY Popularity ASC;

-- Никнеймы игроков и их лучшие предметы, цена которых превышает 4000
SELECT Players.Nickname, Items.ItemName
FROM Players
JOIN GeneralStats ON Players.Nickname = GeneralStats.Nickname
JOIN Items ON GeneralStats.ItemName = Items.ItemName
WHERE Items.Price > 4000
GROUP BY Players.Nickname, Items.ItemName;

-- Никнейм лучшего игрока и средняя частота выбора персонажа, у которых средняя частота выбора персонажа выше 0.050, отсортированных по убыванию средней частоты выбора.
SELECT Characters.BestPlayerNickname, ROUND(AVG(SelectFrequency), 3) AS AvgFrequency
FROM HeroesStats
JOIN Characters ON HeroesStats.CharacterName = Characters.CharacterName
GROUP BY Characters.BestPlayerNickname
HAVING AVG(SelectFrequency) > 0.050
ORDER BY AvgFrequency DESC;

-- Имена героев и их максимальные Winrate, отсортированные по убыванию.
SELECT h.CharacterName, h.Winrate
FROM HeroesStats h
ORDER BY Winrate DESC;

-- Имена героев, никнейм игроков, Winrate и позиции героев в общем рейтинге, отсортированные по порядку убывания Winrate.
SELECT GS.CharacterName, GS.Nickname, GS.Winrate,
        ROW_NUMBER() OVER (ORDER BY GS.Winrate DESC) AS Position
FROM GeneralStats GS
ORDER BY GS.Winrate DESC;

-- Популярность каждого предмета среди игроков, определяемая по количеству покупок, упорядоченная от наименее популярного к наиболее популярному.
SELECT ItemName, Purchases,
       RANK() OVER (ORDER BY Purchases DESC) AS ItemPopularity
FROM ItemsStats;