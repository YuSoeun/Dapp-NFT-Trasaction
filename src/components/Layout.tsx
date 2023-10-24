import React, { FC } from 'react';
import { Stack } from '@chakra-ui/react';
import { Link, Flex } from 'react-router-dom';

const Layout: FC = ({ children }) => {
  return
  <Stack h={100vh}>
    <div>
      <p>Doplin-Animals</p>
    </div>
    <Flex
      direction = "column"
      h="full"
      justifyContent="center"
      alignItems="center"
    >
      (childeren)
      <Link to="/">
        <button>Main</button>
      </Link>
      <Link to="/my-animal">
        <button>My Animal</button>
      </Link>
      <Link to="/sale-animal">
        <button>Sale Animal</button>
      </Link>
    </Flex>
  </Stack>
}

export default Layout;
