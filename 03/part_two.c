#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "uthash.h"

typedef struct {
   int height;
   int width;
   char array[150][150];
} Data;

Data readFile() {
   FILE* f;
   int height, width, ii, jj;
   char array[150][150]; // Assuming the file won't exceed 140x140

   if((f = fopen("./input", "r")) == NULL)
       exit(1);

   // Get the first line to determine the width
   char line[150];
   fgets(line, 150, f);
   width = strlen(line); // Subtract 1 for the newline character

   // Get the number of lines to determine the height
   rewind(f); // Reset the file pointer to the beginning of the file
   height = 0;
   while(fgets(line, 150, f) != NULL)
       height++;

   // Reset the file pointer to the beginning of the file again
   rewind(f);

   // Read the data into the array
   for(jj=0; jj<height; jj++)
       for(ii=0; ii<width; ii++)
           fscanf(f, "%c", &array[jj][ii]);

   fclose(f);

   // Return the data
   Data data;
   data.height = height;
   data.width = width;
   for(jj=0; jj<height; jj++)
       for(ii=0; ii<width; ii++)
           data.array[jj][ii] = array[jj][ii];
   return data;
}

typedef struct {
  int line;
  int startIdx;
  int endIdx;
  int number;
} NumberData;

typedef struct {
 int size;
 NumberData* data;
} NumberDataArray;

NumberDataArray extractNumberData(Data data) {
  int numNumbers = 0;
  for(int jj=0; jj<data.height; jj++){
      for(int ii=0; ii<data.width; ii++){
          if(isdigit(data.array[jj][ii])){
              numNumbers++;
          }
      }
  }

  NumberData* numberDataList = malloc(numNumbers * sizeof(NumberData));
  int index = 0;
  for(int jj=0; jj<data.height; jj++){
      int start = -1;
      for(int ii=0; ii<data.width; ii++){
          // Digit -> Either start tracking new number, or continue number
          if(isdigit(data.array[jj][ii])){
              // Start tracking new number
              if(start == -1) {
                  start = ii;
              }
          }
          // Non-Digit -> Either do nothing, or wrap up currently tracked number
          else {
              if(start != -1) {
                  numberDataList[index].line = jj;
                  numberDataList[index].startIdx = start;
                  numberDataList[index].endIdx = ii - 1;
                  numberDataList[index].number = atoi(&data.array[jj][start]);
                  index++;
                  start = -1;
              }
          }
      }
  }

  NumberDataArray array;
  array.size = index;
  array.data = numberDataList;
  return array;
}

typedef struct {
 int x;
 int y;
} SymbolCoordinate;


SymbolCoordinate* isAdjacentToSymbol(Data data, NumberData numberData) {
  char symbols[] = {'*'};
  int size = sizeof(symbols) / sizeof(symbols[0]);

  // Check the fields directly above, below, left, right, and diagonal to the number
  for(int i=numberData.startIdx; i<=numberData.endIdx; i++){
      if(numberData.line > 0 && strchr(symbols, data.array[numberData.line-1][i]) != NULL) {
          SymbolCoordinate* coord = malloc(sizeof(SymbolCoordinate));
          coord->x = i;
          coord->y = numberData.line - 1;
          return coord;
      }
      if(numberData.line < data.height-1 && strchr(symbols, data.array[numberData.line+1][i]) != NULL) {
          SymbolCoordinate* coord = malloc(sizeof(SymbolCoordinate));
          coord->x = i;
          coord->y = numberData.line + 1;
          return coord;
      }
      if(i > 0 && strchr(symbols, data.array[numberData.line][i-1]) != NULL) {
          SymbolCoordinate* coord = malloc(sizeof(SymbolCoordinate));
          coord->x = i - 1;
          coord->y = numberData.line;
          return coord;
      }
      if(i < data.width-1 && strchr(symbols, data.array[numberData.line][i+1]) != NULL) {
          SymbolCoordinate* coord = malloc(sizeof(SymbolCoordinate));
          coord->x = i + 1;
          coord->y = numberData.line;
          return coord;
      }
  }

  // Check the fields on the diagonals
  if(numberData.line > 0 && numberData.startIdx > 0 && strchr(symbols, data.array[numberData.line-1][numberData.startIdx-1]) != NULL) {
      SymbolCoordinate* coord = malloc(sizeof(SymbolCoordinate));
      coord->x = numberData.startIdx - 1;
      coord->y = numberData.line - 1;
      return coord;
  }
  if(numberData.line < data.height-1 && numberData.endIdx < data.width-1 && strchr(symbols, data.array[numberData.line+1][numberData.endIdx+1]) != NULL) {
      SymbolCoordinate* coord = malloc(sizeof(SymbolCoordinate));
      coord->x = numberData.endIdx + 1;
      coord->y = numberData.line + 1;
      return coord;
  }
  if(numberData.line > 0 && numberData.endIdx < data.width-1 && strchr(symbols, data.array[numberData.line-1][numberData.endIdx+1]) != NULL) {
      SymbolCoordinate* coord = malloc(sizeof(SymbolCoordinate));
      coord->x = numberData.endIdx + 1;
      coord->y = numberData.line - 1;
      return coord;
  }
  if(numberData.line < data.height-1 && numberData.startIdx > 0 && strchr(symbols, data.array[numberData.line+1][numberData.startIdx-1]) != NULL) {
      SymbolCoordinate* coord = malloc(sizeof(SymbolCoordinate));
      coord->x = numberData.startIdx - 1;
      coord->y = numberData.line + 1;
      return coord;
  }

  return NULL;
}

typedef struct {
 SymbolCoordinate key;
 int count;
 int product;
 UT_hash_handle hh;
} CoordinateMap;

void updateCoordinateMap(CoordinateMap** map, SymbolCoordinate coord, int number) {
 CoordinateMap* found;
 HASH_FIND(hh, *map, &coord, sizeof(SymbolCoordinate), found);
 if (found) {
   found->count++;
   if (found->count > 2) {
     found->product = 0;
   } else {
     found->product *= number;
   }
 } else {
   CoordinateMap* new_map = malloc(sizeof(CoordinateMap));
   new_map->key = coord;
   new_map->count = 1;
   new_map->product = number;
   HASH_ADD(hh, *map, key, sizeof(SymbolCoordinate), new_map);
 }
}


int main(void){
  Data data = readFile();
  NumberDataArray numberDataArray = extractNumberData(data);
  CoordinateMap* map_records = NULL;

   // Print the array to verify
   for(int jj=0; jj<data.height; jj++){
       for(int ii=0; ii<data.width; ii++)
           printf ("%c", data.array[jj][ii]);
//        printf("\n");
   }

   int sum = 0;
   // Print the NumberData to verify
   for(int i=0; i<numberDataArray.size; i++){
     SymbolCoordinate* coord = isAdjacentToSymbol(data, numberDataArray.data[i]);
        if(coord != NULL){
            printf("NumberData at line %d, start index %d, end index %d has a symbol in one of the adjacent fields at coordinates (%d, %d)\n",
                   numberDataArray.data[i].line, numberDataArray.data[i].startIdx, numberDataArray.data[i].endIdx, coord->x, coord->y);
            updateCoordinateMap(&map_records, *coord, numberDataArray.data[i].number);
            free(coord);
        }
   }
    CoordinateMap *current, *tmp;
    HASH_ITER(hh, map_records, current, tmp) {
        if (current->count != 2) {
            HASH_DEL(map_records, current);
        }
    }

    // Print the gears
    HASH_ITER(hh, map_records, current, tmp) {
        printf("Coordinate (%d, %d) occurs %d times and the product of the adjacent numbers is %d\n",
              current->key.x, current->key.y, current->count, current->product);
        sum = sum + current->product;
    }
//
//     // Free the hash map
//     HASH_ITER(hh, map, tmp, CoordinateMap) {
//         HASH_DEL(map, tmp);
//         free(tmp);
//     }

   free(numberDataArray.data);
   printf("Total of number parts: %d\n", sum);
   return 0;
}