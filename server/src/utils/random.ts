export function generateRandomNumber(min: number, max: number): number {
  return Math.random() * (max - min) + min;
}

export function generateRandomInt(min: number, max: number): number {
  return Math.floor(generateRandomNumber(Math.ceil(min), Math.floor(max)));
}

export function generateRandomId(): string {
  return generateRandomInt(0, 100000).toString();
}

export function generateNRandomId(n: number): string[] {
  return Array.from({ length: 40 }, generateRandomId);
}

// Credit to: https://stackoverflow.com/questions/2450954/how-to-randomize-shuffle-a-javascript-array
export function shuffleArray<T>(array: T[]): T[] {
  let currentIndex = array.length;
  let randomIndex: number;

  while (currentIndex != 0) {
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex--;

    [array[currentIndex], array[randomIndex]] = [array[randomIndex], array[currentIndex]];
  }

  return array;
}
