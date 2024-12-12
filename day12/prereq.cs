using System;
using System.IO;
using System.Collections.Generic;
using System.Net.NetworkInformation;

namespace Solution
{
    public class  Tile {
        public string type;
        public int x;
        public int y;
        public int edges;

        public bool edge_top = false;
        public bool edge_bottom = false;
        public bool edge_left = false;
        public bool edge_right = false;

        public int area;
        public Tile(int x, int y, int edges, string type){
            this.x = x;
            this.y = y;
            this.type = type;
            this.edges = edges;
            this.area = -1;
        }
    }

    public class Area {
        public List<Tile> tiles;
        public Area(){
            tiles = new List<Tile>();
        }
    }
    
    public class Tools{
        public static List<List<string>> LoadAndDeserialize(string filePath){
            if (File.Exists(filePath))
            {
                string contents = File.ReadAllText(filePath);

                string[] lines = contents.Split('\n', '\n');

                List<List<string>> field = new List<List<string>>();

                for (int i = 0; i < lines.Length; i++)
                {
                    List<string> row = new List<string>();
                    for (int j = 0; j < lines[i].Length; j++)
                    {
                        row.Add(lines[i][j].ToString());
                    }
                    field.Add(row);
                }

                return field;
            }
            else
            {
                Console.WriteLine("File not found: " + filePath);
                return null;
            }
        }
        public static List<List<Tile>> ToTiles(List<List<string>> field){
            List<List<Tile>> tiles = new List<List<Tile>>();

            for (int i = 0; i < field.Count; i++){
                List<Tile> row = new List<Tile>();
                for (int j = 0; j < field[i].Count; j++){
                    int edges = 0;

                    bool edge_bottom = false;
                    bool edge_top = false;
                    bool edge_left = false;
                    bool edge_right = false;

                    if (i == 0){
                        edges++;
                        edge_top = true;
                    }
                    if (j == 0){
                        edges++;
                        edge_left = true;
                    }
                    if(i == field.Count - 1){
                        edges++;
                        edge_bottom = true;
                    }
                    if(j == field[i].Count - 1){
                        edges++;
                        edge_right = true;
                    }

                    if (i > 0 && field[i][j] != field[i - 1][j]){
                        edges++;
                        tiles[i - 1][j].edges++;
                        edge_top = true;
                        tiles[i - 1][j].edge_bottom = true;
                    }
                    if (j > 0 && field[i][j] != field[i][j - 1]){
                        edges++;
                        edge_left = true;
                        row[j-1].edges++;
                        row[j-1].edge_right = true;
                    }
                    Tile tile = new Tile(j, i, edges, field[i][j]);

                    tile.edge_top = edge_top;
                    tile.edge_bottom = edge_bottom;
                    tile.edge_left = edge_left;
                    tile.edge_right = edge_right;

                    row.Add(tile);
                }
                tiles.Add(row);
            }
            return tiles;
        }
        public static void PrintAreas(List<List<Tile>> tiles){
            string alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

            for (int i = 0; i < tiles.Count; i++){
                for (int j = 0; j < tiles[i].Count; j++){
                    if (tiles[i][j].area == -1){
                        Console.Write(".");
                        continue;
                    }
                    if (tiles[i][j].area > 35){
                        Console.Write("?");
                        continue;
                    }
                    Console.Write(alphabet[tiles[i][j].area]);
                }
                Console.WriteLine();
            }
        }

        public static void PrintEdges(List<List<Tile>> tiles){
            for (int i = 0; i < tiles.Count; i++){
                for (int j = 0; j < tiles[i].Count; j++){
                    Console.Write(tiles[i][j].edges);
                }
                Console.WriteLine();
            }
        }
    }

    public class Algo{
        public static void FloodFill(List<List<Tile>> tiles, int x, int y, string distinctchar, Area area, int area_id){
            if (x < 0 || x >= tiles[0].Count || y < 0 || y >= tiles.Count){
                return;
            }
            if (area.tiles.Contains(tiles[y][x])){
                return;
            }
            if (tiles[y][x].type != distinctchar){
                return;
            }

            if (tiles[y][x].area != -1){
                return;
            }

            tiles[y][x].area = area_id;
            
            if (tiles[y][x].edges == 4){
                area.tiles.Add(tiles[y][x]);
                return;
            }
            area.tiles.Add(tiles[y][x]);
            FloodFill(tiles, x + 1, y, distinctchar, area, area_id);
            FloodFill(tiles, x - 1, y, distinctchar, area, area_id);
            FloodFill(tiles, x, y + 1, distinctchar, area, area_id);
            FloodFill(tiles, x, y - 1, distinctchar, area, area_id);
        }

        public static List<string> GetDisctinctChars(List<List<Tile>> tiles){
            List<string> distinctChars = new List<string>();
            for (int i = 0; i < tiles.Count; i++){
                for (int j = 0; j < tiles[i].Count; j++){
                    if (!distinctChars.Contains(tiles[i][j].type)){
                        distinctChars.Add(tiles[i][j].type);
                    }
                }
            }
            return distinctChars;
        }

        public static int CountAreaSides(Area area){
            int min_y = -1;
            int max_y = -1;
            int min_x = -1;
            int max_x = -1;

            for (int i = 0; i < area.tiles.Count; i++){
                if (min_y == -1 || area.tiles[i].y < min_y){
                    min_y = area.tiles[i].y;
                }
                if (max_y == -1 || area.tiles[i].y > max_y){
                    max_y = area.tiles[i].y;
                }
                if (min_x == -1 || area.tiles[i].x < min_x){
                    min_x = area.tiles[i].x;
                }
                if (max_x == -1 || area.tiles[i].x > max_x){
                    max_x = area.tiles[i].x;
                }
            }

            //Console.WriteLine(min_x + " " + max_x + " " + min_y + " " + max_y);

            List<List<Tile>> map = new List<List<Tile>>();

            for (int i = min_y; i < max_y+3; i++){
                List<Tile> row = new List<Tile>();
                for (int j = min_x; j < max_x+3; j++){
                    row.Add(null);
                }
                map.Add(row);
            }

            for (int i = 0; i < area.tiles.Count; i++){
                //if (area.tiles[i].edges > 0){
                    map[area.tiles[i].y - min_y+1][area.tiles[i].x - min_x+1] = area.tiles[i];
                //}
            }

            int sides = 0;
            bool top_side = false;
            bool bottom_side = false;

            //left -> right
            for (int i = 0; i < map.Count; i++){
                for (int j = 0; j < map[0].Count; j++){
                    if (map[i][j] != null){
                        if (map[i][j].edge_top){
                            top_side = true;
                        }
                        if (map[i][j].edge_bottom){
                            bottom_side = true;
                        }

                        if (!map[i][j].edge_top){
                            if (top_side){
                                sides++;
                            }
                            top_side = false;
                        }
                        if (!map[i][j].edge_bottom){
                            if (bottom_side){
                                sides++;
                            }
                            bottom_side = false;
                        }
                    } else {
                        if (top_side){
                            sides++;
                        }
                        if (bottom_side){
                            sides++;
                        }
                        top_side = false;
                        bottom_side = false;
                    }
                }
            }

            //top -> bottom
            for (int i = 0; i < map[0].Count; i++){
                for (int j = 0; j < map.Count; j++){
                    if (map[j][i] != null){
                        if (map[j][i].edge_left){
                            top_side = true;
                        }
                        if (map[j][i].edge_right){
                            bottom_side = true;
                        }

                        if (!map[j][i].edge_left){
                            if (top_side){
                                sides++;
                            }
                            top_side = false;
                        }
                        if (!map[j][i].edge_right){
                            if (bottom_side){
                                sides++;
                            }
                            bottom_side = false;
                        }
                    } else {
                        if (top_side){
                            sides++;
                        }
                        if (bottom_side){
                            sides++;
                        }
                        top_side = false;
                        bottom_side = false;
                    }
                }
            }


            /*for (int i = 0; i < map.Count; i++){
                for (int j = 0; j < map[i].Count; j++){
                    if (map[i][j] == null){
                        Console.Write(".");
                    } else {
                        Console.Write(map[i][j].type);
                    }
                }
                Console.WriteLine();
            }*/
            return sides;
        }
    }
}