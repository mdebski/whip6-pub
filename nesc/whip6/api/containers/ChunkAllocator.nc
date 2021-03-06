/*
 * whip6: Warsaw High-performance IPv6.
 *
 * Copyright (c) 2012-2016 InviNets Sp z o.o.
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached LICENSE     
 * files. If you do not find these files, copies can be found by writing
 * to technology@invinets.com.
 */



/**
 * Allocator which can allocate blocks of memory of constant size.
 *
 * @author Szymon Acedanski <accek@mimuw.edu.pl>
 */
interface ChunkAllocator
{
    /**
     * Returns the size of a chunk in bytes.
     * @return size of a chunk.
     */
    command size_t getChunkSize();

    /**
     * Allocates a chunk.
     * @return pointer to the allocated data or NULL, if there's no memory
     *         left.
     */
    command uint8_t_xdata * allocateChunk();

    /**
     * Frees the previously allocated chunk.
     */
    command void freeChunk(uint8_t_xdata * chunk);
}
