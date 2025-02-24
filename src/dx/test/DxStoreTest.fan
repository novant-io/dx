//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   21 Jul 2024  Andy Frank  Creation
//

@Js class DxStoreTest : AbstractDxTest
{

//////////////////////////////////////////////////////////////////////////
// Basics
//////////////////////////////////////////////////////////////////////////

  Void testEmpty()
  {
    a := DxStore(1, [:])
    verifyEq(a.buckets, Str[,])
    verifyErr(ArgErr#) { x := a.get("foo", 1) }

    b := DxStore(1, ["foo":DxRec#.emptyList])
    verifyEq(b.buckets, ["foo"])
    verifyEq(b.size("foo"), 0)
    verifyEq(b.get("foo", 1), null)
    verifyErr(ArgErr#) { x := a.get("bar", 1) }

    c := DxStore(1, ["foo":DxRec#.emptyList, "bar":DxRec#.emptyList])
    verifyEq(c.buckets.sort, ["bar", "foo"])
    verifyEq(c.size("foo"), 0)
    verifyEq(c.size("bar"), 0)
    verifyEq(c.get("foo", 1), null)
    verifyEq(c.get("bar", 1), null)
    verifyErr(ArgErr#) { x := a.get("zar", 1) }
  }

  Void testBasics()
  {
    a := DxStore(1, ["foo":[
      DxRec(["id":1, "a":12, "b":"foo", "c":false]),
      DxRec(["id":2, "a":24, "b":"bar", "c":true]),
      DxRec(["id":3, "a":18, "b":"zar", "c":false]),
    ]])

    verifyEq(a.buckets, ["foo"])
    verifyEq(a.version, 1)
    verifyEq(a.size("foo"), 3)
    verifyEq(a.keys("foo").rw.sort, Str["a", "b", "c", "id"])
    verifyRec(a.get("foo", 1), ["id":1, "a":12, "b":"foo", "c":false])
    verifyRec(a.get("foo", 2), ["id":2, "a":24, "b":"bar", "c":true])
    verifyRec(a.get("foo", 3), ["id":3, "a":18, "b":"zar", "c":false])

    // verify each
    verifyBucket(a, "foo", [
      ["id":1, "a":12, "b":"foo", "c":false],
      ["id":2, "a":24, "b":"bar", "c":true],
      ["id":3, "a":18, "b":"zar", "c":false],
    ])

    // add some recs
    w := DxWriter(a)
    w.add("foo", ["id":4, "a":33, "b":"car"])
    w.add("foo", ["id":5, "a":99, "b":"lar"])
    b := w.commit
    verify(a !== b)
    verifyEq(a.version, 1)
    verifyEq(b.version, 2)
    verifyEq(a.size("foo"), 3)
    verifyEq(b.size("foo"), 5)
    verifyRec(b.get("foo", 1), ["id":1, "a":12, "b":"foo", "c":false])
    verifyRec(b.get("foo", 2), ["id":2, "a":24, "b":"bar", "c":true])
    verifyRec(b.get("foo", 3), ["id":3, "a":18, "b":"zar", "c":false])
    verifyRec(b.get("foo", 4), ["id":4, "a":33, "b":"car"])
    verifyRec(b.get("foo", 5), ["id":5, "a":99, "b":"lar"])

    // find
    verifyEq(b.find("foo") |r| { r->a == -1 }, null)
    verifyEq(b.find("foo") |r| { r->a == 24 }->id, 2)
    verifyEq(b.find("foo") |r| { r->b == "zar" }->id, 3)

    // any
    verifyEq(b.any("foo") |r| { r->a == -1 },    false)
    verifyEq(b.any("foo") |r| { r->a == 24 },    true)
    verifyEq(b.any("foo") |r| { r->b == "zar" }, true)

    // update some recs
    w = DxWriter(b)
    w.update("foo", 1, ["a":77, "b":"cool beans"])
    c := w.commit
    verify(a !== b)
    verify(b !== c)
    verify(a !== c)
    verifyEq(a.version, 1)
    verifyEq(b.version, 2)
    verifyEq(c.version, 3)
    verifyEq(a.size("foo"), 3)
    verifyEq(b.size("foo"), 5)
    verifyEq(c.size("foo"), 5)
    verifyRec(a.get("foo", 1), ["id":1, "a":12, "b":"foo",        "c":false])
    verifyRec(b.get("foo", 1), ["id":1, "a":12, "b":"foo",        "c":false])
    verifyRec(c.get("foo", 1), ["id":1, "a":77, "b":"cool beans", "c":false])

    // delete some recs
    w = DxWriter(a)
    w.delete("foo", 1)
    d := w.commit
    verify(a !== d)
    verifyEq(a.version, 1)
    verifyEq(b.version, 2)
    verifyEq(c.version, 3)
    verifyEq(d.version, 2)  // since we started with 'a' we move to 2
    verifyEq(a.size("foo"), 3)
    verifyEq(b.size("foo"), 5)
    verifyEq(c.size("foo"), 5)
    verifyEq(d.size("foo"), 2)
    verifyRec(a.get("foo", 1), ["id":1, "a":12, "b":"foo",        "c":false])
    verifyRec(b.get("foo", 1), ["id":1, "a":12, "b":"foo",        "c":false])
    verifyRec(c.get("foo", 1), ["id":1, "a":77, "b":"cool beans", "c":false])
    verifyEq( d.get("foo", 1), null)

    // verify cannot change 'id'
    w = DxWriter(a)
    w.update("foo", 1, ["id":99, "a":88])
    e := w.commit
    verifyRec(e.get("foo", 1), ["id":1, "a":88, "b":"foo", "c":false])

    // remove fields
    w = DxWriter(a)
    w.update("foo", 1, ["b":null, "c":null])
    f := w.commit
    verifyRec(f.get("foo", 1), ["id":1, "a":12])
  }
}