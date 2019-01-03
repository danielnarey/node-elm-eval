import test from 'ava';
import { call } from './index';

test('this', async (t) => {
  const result = await call({ f: '(+)', args: [1, -1] });

  t.is(result, 0);
});
