export const all = (selector, event, listener) => {
  document.querySelectorAll(selector).forEach(e => {
    e.addEventListener(event, listener);
  });
};

export const grab = selector => {
  const nodes = document.querySelectorAll(selector);

  if (nodes) {
    return Array.from(nodes.values()).map(n => new ProperNode(n));
  }
};

const noNode = {
  present: false,

  prop: (name, value) => {},
  on: (event, handler) => {},
  add: classname => {},
  remove: classname => {},
  toggle: classname => {},
  set text(value) {},
  get: name => {},
  value: () => {},
  data: name => {}
};

export const $ = selector => {
  const node = document.querySelector(selector);
  if (node) {
    return new ProperNode(node);
  } else {
    return noNode;
  }
};

class ProperNode {
  constructor(realNode) {
    this.node = realNode;
    this.present = true;
  }

  prop(name, value) {
    this.node.setAttribute(name, value);
  }

  on(event, handler) {
    this.node.addEventListener(event, handler);
  }

  add(classname) {
    this.node.classList.add(classname);
  }

  remove(classname) {
    this.node.classList.remove(classname);
  }

  toggle(classname) {
    this.node.classList.toggle(classname);
  }

  set text(value) {
    this.node.textContent = value;
  }

  get(name) {
    return this.node.attributes[name].value;
  }

  value() {
    return this.node.value;
  }

  data(name) {
    return this.node.dataset[name];
  }
}
