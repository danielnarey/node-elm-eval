import test from 'ava';
import {
  expr,
  call,
  partialExpr,
  partialCall,
} from './index';

test('(+) 1 2', async (t) => {
  const exprResult = await expr('(+)', 1, 2);
  const callResult = await call({ f: '(+)', args: [1, 2] });
  const partialExprResult = await partialExpr('(+)', 2)(1);
  const partialCallResult = await partialCall({ f: '(+)', args: [2] })(1);

  t.true([
    exprResult,
    callResult,
    partialExprResult,
    partialCallResult,
  ].every(x => x === 3));
});

test('(+) 1 2.0', async (t) => {
  const result = await expr('(+)', 1, 2.0);

  t.is(result, 3);
  t.is(result, 3.0);
});

test('(+) 1 "a"', async (t) => {
  await t.throwsAsync(
    expr('(+)', 1, 'a'),
    { instanceOf: TypeError },
  );
});

test('(+) 1 true', async (t) => {
  await t.throwsAsync(
    expr('(+)', 1, true),
    { instanceOf: TypeError },
  );
});

test('(+) 1', async (t) => {
  await t.throwsAsync(
    expr('(+)', 1),
    { instanceOf: TypeError },
  );
});

test('(+)', async (t) => {
  await t.throwsAsync(
    expr('(+)'),
    { instanceOf: TypeError },
  );
});

test('(+) 1 2 3', async (t) => {
  await t.throwsAsync(
    expr('(+)', 1, 2, 3),
    { instanceOf: TypeError },
  );
});

test('(/) 0 0', async (t) => {
  const result = await expr('(/)', 0, 0);

  t.is(result, NaN);
});

test('round 3.4', async (t) => {
  const result = await expr('round', 3.4);

  t.is(result, 3);
});

test('round 3', async (t) => {
  const result = await expr('round', 3);

  t.is(result, 3);
});

test('(==) 1 1', async (t) => {
  await t.throwsAsync(
    expr('(==)', 1, 1),
    { instanceOf: TypeError },
  );
});

test('pi', async (t) => {
  const result = await expr('pi');

  t.is(result, Math.PI);
});

test('not false', async (t) => {
  const result = await expr('not', false);

  t.true(result);
});

test('(||) false true', async (t) => {
  const result = await expr('(||)', false, true);

  t.true(result);
});

test('toPolar 0 0', async (t) => {
  const result = await expr('toPolar', 0, 0);

  t.deepEqual(result, [0, 0]);
});

test('fromPolar 0 0', async (t) => {
  const result = await expr('fromPolar', 0, 0);

  t.deepEqual(result, [0, 0]);
});

test('isNaN NaN', async (t) => {
  const result = await expr('isNaN', NaN);

  t.true(result);
});

test('isInfinite Infinity', async (t) => {
  const result = await expr('isInfinite', Infinity);

  t.true(result);
});

test('identity "a"', async (t) => {
  const result = await expr('identity', 'a');

  t.is(result, 'a');
});

test('always "a" "b"', async (t) => {
  const result = await expr('always', 'a', 'b');

  t.is(result, 'a');
});

test('List.singleton "a"', async (t) => {
  const result = await expr('List.singleton', 'a');

  t.deepEqual(result, ['a']);
});

test('(::) "a" []', async (t) => {
  const result = await expr('(::)', 'a', []);

  t.deepEqual(result, ['a']);
});

test('(::) "a" ["b", "c"]', async (t) => {
  const result = await expr('(::)', 'a', ['b', 'c']);

  t.deepEqual(result, ['a', 'b', 'c']);
});

test('(::) "a" [1, 2]', async (t) => {
  const result = await expr('(::)', 'a', [1, 2]);

  t.deepEqual(result, ['a', 1, 2]);
});

test('List.head [1, 2, 3]', async (t) => {
  const result = await expr('List.head', [1, 2, 3]);

  t.is(result, 1);
});

test('List.head []', async (t) => {
  await t.throwsAsync(
    expr('List.head', []),
    { instanceOf: TypeError },
  );
});

test('List.tail [1, 2, 3]', async (t) => {
  const result = await expr('List.tail', [1, 2, 3]);

  t.deepEqual(result, [2, 3]);
});

test('List.tail []', async (t) => {
  await t.throwsAsync(
    expr('List.tail', []),
    { instanceOf: TypeError },
  );
});

test('List.unzip [[2, 3], [4, 5], [6, 7]]', async (t) => {
  const result = await expr('List.unzip', [[2, 3], [4, 5], [6, 7]]);

  t.deepEqual(result, [[2, 4, 6], [3, 5, 7]]);
});

test('Array.empty', async (t) => {
  const result = await expr('Array.empty');

  t.deepEqual(result, []);
});

test('Array.fromList [1, 2, 3]', async (t) => {
  const result = await expr('Array.fromList', [1, 2, 3]);

  t.deepEqual(result, [1, 2, 3]);
});

test('Array.isEmpty []', async (t) => {
  const result = await expr('Array.isEmpty', []);

  t.true(result);
});

test('Array.get 2 [1, 2, 3]', async (t) => {
  const result = await expr('Array.get', 2, [1, 2, 3]);

  t.is(result, 3);
});

test('Array.get 3 [1, 2, 3]', async (t) => {
  await t.throwsAsync(
    expr('Array.get', 3, [1, 2, 3]),
    { instanceOf: TypeError },
  );
});

test('Array.set 2 9 [1, 2, 3]', async (t) => {
  const result = await expr('Array.set', 2, 9, [1, 2, 3]);

  t.deepEqual(result, [1, 2, 9]);
});

test('Array.set 3 9 [1, 2, 3]', async (t) => {
  await t.throwsAsync(
    expr('Array.set', 3, 9, [1, 2, 3]),
    { instanceOf: TypeError },
  );
});

test('Set.empty', async (t) => {
  const result = await expr('Set.empty');

  t.deepEqual(result, []);
});

test('Set.singleton.string "a"', async (t) => {
  const result = await expr('Set.singleton.string', 'a');

  t.deepEqual(result, ['a']);
});

test('Set.singleton.int 3.0', async (t) => {
  await t.throwsAsync(
    expr('Set.singleton.string', 3.0),
    { instanceOf: TypeError },
  );
});

test('Set.insert.int 3 [1, 1, 1, 2, 2]', async (t) => {
  const result = await expr('Set.insert.int', 3, [1, 1, 1, 2, 2]);

  t.deepEqual(result, [1, 2, 3]);
});

test('Set.insert.int 1 [1, 1, 1, 2, 2]', async (t) => {
  const result = await expr('Set.insert.int', 1, [1, 1, 1, 2, 2]);

  t.deepEqual(result, [1, 2]);
});

test('Set.remove.string "a" ["a", "a", "a", "b", "b"]', async (t) => {
  const result = await expr('Set.remove.string', 'a', ['a', 'a', 'a', 'b', 'b']);

  t.deepEqual(result, ['b']);
});

test('Set.remove.string "c" ["a", "a", "a", "b", "b"]', async (t) => {
  const result = await expr('Set.remove.string', 'c', ['a', 'a', 'a', 'b', 'b']);

  t.deepEqual(result, ['a', 'b']);
});

test('Set.size.int [1, 1, 1, 2, 2]', async (t) => {
  const result = await expr('Set.size.int', [1, 1, 1, 2, 2]);

  t.is(result, 2);
});

test('Set.union.int [1, 2] [1, 3]', async (t) => {
  const result = await expr('Set.union.int', [1, 2], [1, 3]);

  t.deepEqual(result, [1, 2, 3]);
});

test('Set.union.float [1, 2, 3] [3.0]', async (t) => {
  const result = await expr('Set.union.float', [1, 2, 3], [3.0]);

  t.deepEqual(result, [1, 2, 3]);
});

test('Set.fromList.string ["a", "a", "a", "b", "b"]', async (t) => {
  const result = await expr('Set.fromList.string', ['a', 'a', 'a', 'b', 'b']);

  t.deepEqual(result, ['a', 'b']);
});

test('Tuple.pair "a" 1', async (t) => {
  const result = await expr('Tuple.pair', 'a', 1);

  t.deepEqual(result, ['a', 1]);
});

test('Tuple.first ["a", 1]', async (t) => {
  const result = await expr('Tuple.first', ['a', 1]);

  t.is(result, 'a');
});
