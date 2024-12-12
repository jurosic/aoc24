using System;
using System.IO;
using System.Collections.Generic;
using System.Runtime.ConstrainedExecution;

namespace Solution
{
    public class p2
    {
        public static int solve()
        {
            List<List<string>> field = Tools.LoadAndDeserialize("12.txt");
            if (field == null){
                return -1;
            }
            List<List<Tile>> tiles = Tools.ToTiles(field);
            List<string> disctinctchars = Algo.GetDisctinctChars(tiles);

            List<Area> areas = new List<Area>();

            for (int i = 0; i < disctinctchars.Count; i++){
                for (int j = 0; j < tiles.Count; j++){
                    for (int k = 0; k < tiles[j].Count; k++){
                        if (tiles[j][k].type == disctinctchars[i]){
                            Area area = new Area();
                            Algo.FloodFill(tiles, k, j, disctinctchars[i], area, areas.Count);
                            if (area.tiles.Count > 0){
                                areas.Add(area);
                            }
                        }
                    }
                }
            }

            //Tools.PrintAreas(tiles);
            //Tools.PrintEdges(tiles);
            //Console.WriteLine(areas.Count);

            //Console.WriteLine(Algo.CountAreaSides(areas[0]));

            int sum = 0;
            for (int i = 0; i < areas.Count; i++){
                //Console.WriteLine("----------------");
                sum += (Algo.CountAreaSides(areas[i]) * areas[i].tiles.Count);
            };

            return sum;
        }
    }
}