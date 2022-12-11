struct DWrapper {
    flat2dArray: [Field: N]
}


impl DWrapper {
    fn peek(self: DWrapper, row: comptime Field, column: comptime Field, internalLen: comptime Field) -> Field {
        let index: comptime Field = internalLen * row + column;        
        let peeked = self.flat2dArray[index];

        peeked
    }

    fn insert(mut self: DWrapper, row: comptime Field, column: comptime Field, internalLen: comptime Field, value: Field) {
        let index: comptime Field = internalLen * row + column;
        self.flat2dArray[index] = value;
    }

    fn new(rows: comptime Field, columns: comptime Field) -> DWrapper {
        let N: comptime Field = rows * columns;
        let mut arr2d: [Field; N] =  [0; N];
        
        DWrapper {
            flat2dArray: arr2d,
        }
    }
}