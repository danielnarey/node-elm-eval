const { Main } = require('./main.js').Elm;


const expr = (f, ...args) => new Promise((resolve, reject) => {
  const program = Main.init();

  program.ports.outgoing.subscribe(m => (
    m.resolve ? resolve(m.value) : reject(new TypeError(m.error))
  ));
  program.ports.incoming.send({
    f,
    args,
  });
});


const call = ({ f, args }) => new Promise((resolve, reject) => {
  const program = Main.init();

  program.ports.outgoing.subscribe(m => (
    m.resolve ? resolve(m.value) : reject(new TypeError(m.error))
  ));
  program.ports.incoming.send({ f, args });
});


const partialExpr = (f, ...args) => data => new Promise((resolve, reject) => {
  const program = Main.init();

  program.ports.outgoing.subscribe(m => (
    m.resolve ? resolve(m.value) : reject(new TypeError(m.error))
  ));
  program.ports.incoming.send({
    f,
    args: args.concat([data]),
  });
});


const partialCall = ({ f, args }) => data => new Promise((resolve, reject) => {
  const program = Main.init();

  program.ports.outgoing.subscribe(m => (
    m.resolve ? resolve(m.value) : reject(new TypeError(m.error))
  ));
  program.ports.incoming.send({
    f,
    args: args.concat([data]),
  });
});


module.exports = {
  expr,
  call,
  partialExpr,
  partialCall,
};
