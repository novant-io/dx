//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   21 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** ConstMapTest
*************************************************************************

@Js class ConstMapTest : Test
{

//////////////////////////////////////////////////////////////////////////
// testEmpty
//////////////////////////////////////////////////////////////////////////

  Void testEmpty()
  {
    a := ConstMap()
    b := ConstMap()
    verifyEq(a.size, 0)
    verifyEq(b.size, 0)
    verifyEq(ConstMap.empty.size, 0)
    verify(a === b)
    verify(a === ConstMap.empty)
  }

//////////////////////////////////////////////////////////////////////////
// testSet
//////////////////////////////////////////////////////////////////////////

  Void testSetBasics()
  {
    a := ConstMap()
    b := a.set(5, "foo")
    verify(a !== b)
    verifyEq(a.size, 0)
    verifyEq(b.size, 1)
    verifyEq(a.get(5), null)
    verifyEq(b.get(5), "foo")

    c := b.set(8, false)
    verify(a !== b)
    verify(b !== c)
    verifyEq(a.size, 0)
    verifyEq(b.size, 1)
    verifyEq(c.size, 2)
    verifyEq(a.get(5), null)
    verifyEq(b.get(5), "foo")
    verifyEq(c.get(5), "foo")
    verifyEq(a.get(8), null)
    verifyEq(b.get(8), null)
    verifyEq(c.get(8), false)

    // not immutable
    verifyErr(NotImmutableErr#) { c.set(10, [1,2,3]) }
  }

  Void testSetKeys()
  {
    temp := Int:Int[:]
    while (temp.size < 10_000)
    {
      id := Int.random(0..4_294_967_296)
      temp[id] = id
    }

    m := ConstMap()
    temp.keys.each |id| { m = m.set(id, id) }
    verifyEq(m.size, temp.size)
  }

  Void testSetBig()
  {
    count := 100_000

    m := ConstMap()
    count.times |x| { m = m.set(x, x) }
    verifyEq(m.size, count)

    sum := 0
    m.each |Int v| { sum += v }
    verifyEq(sum, 4_999_950_000)
  }

//////////////////////////////////////////////////////////////////////////
// testAdd
//////////////////////////////////////////////////////////////////////////

  Void testAddBasics()
  {
    m := ConstMap()
    m = m.add(2, "alpha")
    m = m.add(4, "beta")
    m = m.add(6, "gamma")

    verifyErr(ArgErr#) { m = m.add(2, "err") }
    verifyErr(ArgErr#) { m = m.add(4, "err") }
    verifyErr(ArgErr#) { m = m.add(6, "err") }
  }

//////////////////////////////////////////////////////////////////////////
// testGet
//////////////////////////////////////////////////////////////////////////

  Void testGet()
  {
    count := 10_000

    m := ConstMap()
    count.times |x| { m = m.set(x, "foo-${x}") }
    verifyEq(m.size, count)

    count.times |c|
    {
      v := m.get(c)
      verifyEq(v, "foo-${c}")
    }
  }

//////////////////////////////////////////////////////////////////////////
// testRemove
//////////////////////////////////////////////////////////////////////////

  Void testRemoveBasics()
  {
    m := ConstMap()
    m = m.set(5, "epsilon")
    m = m.set(4, "delta")
    m = m.set(3, "gamma")
    m = m.set(2, "beta")
    m = m.set(1, "alpha")
    verifyEq(m.size, 5)

    a := m.remove(3)
    verify(a !== m)
    verifyEq(m.size, 5)
    verifyEq(a.size, 4)
    verifyEq(m.get(3), "gamma")
    verifyEq(a.get(3), null)

    b := a.remove(1)
    verify(a !== m)
    verify(b !== a)
    verifyEq(m.size, 5)
    verifyEq(a.size, 4)
    verifyEq(b.size, 3)
    // 3
    verifyEq(m.get(3), "gamma")
    verifyEq(a.get(3), null)
    verifyEq(b.get(3), null)
    // 1
    verifyEq(m.get(1), "alpha")
    verifyEq(a.get(1), "alpha")
    verifyEq(b.get(1), null)

    c := b.remove(2)
    verify(a !== m)
    verify(b !== a)
    verify(c !== b)
    verifyEq(m.size, 5)
    verifyEq(a.size, 4)
    verifyEq(b.size, 3)
    verifyEq(c.size, 2)
    // 3
    verifyEq(m.get(3), "gamma")
    verifyEq(a.get(3), null)
    verifyEq(b.get(3), null)
    verifyEq(c.get(3), null)
    // 1
    verifyEq(m.get(1), "alpha")
    verifyEq(a.get(1), "alpha")
    verifyEq(b.get(1), null)
    verifyEq(c.get(1), null)
    // 2
    verifyEq(m.get(2), "beta")
    verifyEq(a.get(2), "beta")
    verifyEq(b.get(2), "beta")
    verifyEq(c.get(2), null)

    d := c.remove(5)
    verify(a !== m)
    verify(b !== a)
    verify(c !== b)
    verify(d !== c)
    verifyEq(m.size, 5)
    verifyEq(a.size, 4)
    verifyEq(b.size, 3)
    verifyEq(c.size, 2)
    verifyEq(d.size, 1)
    // 3
    verifyEq(m.get(3), "gamma")
    verifyEq(a.get(3), null)
    verifyEq(b.get(3), null)
    verifyEq(c.get(3), null)
    verifyEq(d.get(3), null)
    // 1
    verifyEq(m.get(1), "alpha")
    verifyEq(a.get(1), "alpha")
    verifyEq(b.get(1), null)
    verifyEq(c.get(1), null)
    verifyEq(d.get(1), null)
    // 2
    verifyEq(m.get(2), "beta")
    verifyEq(a.get(2), "beta")
    verifyEq(b.get(2), "beta")
    verifyEq(c.get(2), null)
    verifyEq(d.get(2), null)
    // 5
    verifyEq(m.get(5), "epsilon")
    verifyEq(a.get(5), "epsilon")
    verifyEq(b.get(5), "epsilon")
    verifyEq(c.get(5), "epsilon")
    verifyEq(d.get(5), null)

    e := d.remove(4)
    verify(a !== m)
    verify(b !== a)
    verify(c !== b)
    verify(d !== c)
    verify(e !== d)
    verifyEq(m.size, 5)
    verifyEq(a.size, 4)
    verifyEq(b.size, 3)
    verifyEq(c.size, 2)
    verifyEq(d.size, 1)
    verifyEq(e.size, 0)

    x := a.remove(10)
    verify(x === a)
  }

  Void testRemoveBig()
  {
    count := 10_000

    m := ConstMap()
    count.times |x| { m = m.set(x, x) }
    verifyEq(m.size, count)

    cur := m.size
    count.times |c|
    {
      m = m.remove(c)
      verifyEq(m.size, --cur)
    }

    verifyEq(m.size, 0)
  }

//////////////////////////////////////////////////////////////////////////
// testEach
//////////////////////////////////////////////////////////////////////////

  Void testEach()
  {
    m := ConstMap()
    128.times |x| { m = m.set(x, x) }
    verifyEq(m.size, 128)

    y := 0
    z := 0
    m.each |Int x| { y++; z+=x }
    verifyEq(y, 128)
    verifyEq(z, 8128)
  }
}
