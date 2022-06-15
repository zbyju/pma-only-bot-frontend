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
