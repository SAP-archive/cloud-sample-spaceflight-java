## cds.reflect

Provides core reflection for CDS models in CSN format. 

Find the 'official' documentation here: https://github.wdf.sap.corp/pages/cdx/API#cds-reflect

### Local usage in a project

```
npm i https://github.wdf.sap.corp/cdx/cds-reflect.git
```

```js
const cds = require('@sap/cds-reflect')

// then use it as described in the above docs, e.g....
let model = cds.reflect ({
  namespace: 'foo.bar',
  definitions: {
    Foo: {kind:'entity', elements:{
      bar: {type:'cds.Association', target:'foo.bar.Bar'}
    }},
    Bar: {kind:'entity'},
  }
})
let { Foo, Bar } = m.exports
```